// Copyright (C) 2022 Intel Corporation
//
// This software and the related documents are Intel copyrighted materials, and
// your use of them is governed by the express license under which they were
// provided to you ("License"). Unless the License provides otherwise, you may
// not use, modify, copy, publish, distribute, disclose or transmit this
// software or the related documents without Intel's prior written permission.
//
// This software and the related documents are provided as is, with no express
// or implied warranties, other than those that are expressly stated in the
// License.
//
// -----------------------------------------------------------------------------
// File: uc_tcp_ip_init.c
// -----------------------------------------------------------------------------

/*
*********************************************************************************************************
*                                            EXAMPLE CODE
*
*               This file is provided as an example on how to use Micrium products.
*
*               Please feel free to use any application code labeled as 'EXAMPLE CODE' in
*               your application products.  Example code may be used as is, in whole or in
*               part, or may be used as a reference only. This file can be modified as
*               required to meet the end-product requirements.
*
*********************************************************************************************************
*/

/*******************************************************************************
 * Includes
 ******************************************************************************/
/*
 * Order is important here - include uc_tcp_ip_init.h before otherwise you'll
 * get redefinition errors for 'suseconds_t' since it's defined by both newlib
 * and 'uC-TCP-IP/Source/net_bsd.h'
 */
// Project
#include "uc_tcp_ip_init.h"
#include "log.h"

// System
#include <stdio.h>
#include <string.h>

// BSP
#include <altera_avalon_tse.h>

// uC
#include <UCOSII/inc/os.h>
#include <Source/dhcp-c.h>

/*******************************************************************************
 * Configurations
 ******************************************************************************/

#define TX_TASK_SIZE  (4096u)
#define RX_TASK_SIZE  (4096u)
#define TMR_TASK_SIZE (4096u)

static const unsigned TX_TASK_PRIO  = 1u;
static const unsigned RX_TASK_PRIO  = 3u;
static const unsigned TMR_TASK_PRIO = 5u;

// DHCP time wait
static const unsigned long DHCP_WAIT_MS = 500u;

// When stopping a network interface, how many times should we to try to stop
// before giving up?
static const unsigned NET_STOP_MAX_TRIES = 10u;

/*******************************************************************************
 * Definitions
 ******************************************************************************/

// These may need adjustment
static const CPU_INT08U NUM_RX_LISTS = 2;
static const NET_BUF_QTY NUM_RX_BUFFERS =
    2 * NUM_RX_LISTS * ALTERA_TSE_MSGDMA_RX_DESC_CHAIN_SIZE;

/**
 * Only one of {Rx,Tx}BufPoolType can go into the dedicated descriptor memory.
 * Since Tx only holds a few buffers at a time and can only *send* one at a
 * time, it's best to have the Rx descriptor buffers in dedicated memory if
 * present.
 */
static NET_DEV_CFG_ETHER NetDev_Cfg_Ether_TSE = {

    .RxBufPoolType    = NET_IF_MEM_TYPE_DEDICATED,
    .RxBufLargeSize   = 1536u,
    .RxBufLargeNbr    = NUM_RX_BUFFERS,
    .RxBufAlignOctets = 4u,
    .RxBufIxOffset    = 2u,                  /* TSE pads two bytes in front of actual data. */

    .TxBufPoolType    = NET_IF_MEM_TYPE_MAIN,
    .TxBufLargeSize   = 1518u,
    .TxBufLargeNbr    = 5u,
    .TxBufSmallSize   = 60u,
    .TxBufSmallNbr    = 5u,
    .TxBufAlignOctets = 4u,
    .TxBufIxOffset    = 0u,


    // Dedicated memory base + size.
    .MemAddr    = SYS_DESC_MEM_BASE,
    .MemSize    = SYS_DESC_MEM_SPAN,

    .Flags =  NET_DEV_CFG_FLAG_NONE,

    .RxDescNbr = 8u, // NOTE: Not configurable.
    .TxDescNbr = 1u, // NOTE: Not configurable.


    // Note this BaseAddr should be address of a alt_tse_system_info struct that
    // the application configures.
    .BaseAddr           = 0,
    .DataBusSizeNbrBits = 0,

    // Desired MAC address.
    .HW_AddrStr = "",
};

// Static task stack allocation.
static OS_STK TX_TASK[TX_TASK_SIZE];
static OS_STK RX_TASK[RX_TASK_SIZE];
static OS_STK TMR_TASK[TMR_TASK_SIZE];

const  NET_TASK_CFG  NetRxTaskCfg = {
        RX_TASK_PRIO,                                           /* RX task priority                    (see Note #1).   */
        RX_TASK_SIZE,                                           /* RX task stack size in bytes         (see Note #2).   */
        RX_TASK,                                                /* RX task stack pointer               (See Note #3).   */
};

const  NET_TASK_CFG  NetTxDeallocTaskCfg = {
        TX_TASK_PRIO,                                           /* TX Dealloc task priority            (see Note #1).   */
        TX_TASK_SIZE,                                           /* TX Dealloc task stack size in bytes (see Note #2).   */
        TX_TASK,                                                /* TX Dealloc task stack pointer       (See Note #3).   */
};

const  NET_TASK_CFG  NetTmrTaskCfg = {
        TMR_TASK_PRIO,                                          /* Timer task priority                 (see Note #1).   */
        TMR_TASK_SIZE,                                          /* Timer task stack size in bytes      (see Note #2).   */
        TMR_TASK,                                               /* Timer task stack pointer            (See Note #3).   */
};

/*******************************************************************************
 * Private Functions
 ******************************************************************************/

/**
 * Convert an string IP address to a 32-bit unsigned int IP address.
 *
 * @param ip_str The string representation of the IP address.
 * @param ip_int Pointer to an INT32U where we can store the int representation.
 *
 * @return true if success, false otherwise.
 */
static BOOLEAN convert_ip_str_to_int (char *ip_str, CPU_INT32U *ip_int) {
    NET_ERR err;

    NetASCII_Str_to_IP(ip_str, ip_int, NET_IPv4_ADDR_SIZE, &err);
    if (err != NET_ASCII_ERR_NONE) {
        logf("FAILED to convert string IPv4 Address '%s' to INT32U.\n",
            ip_str);
        return DEF_FALSE;
    }

    return DEF_TRUE;
}

/*
*********************************************************************************************************
*                                            AppInit_DHCPc()
*
* Description : This function initialize uC/DHCPc and start DHCPc negotiation for the interface. This function
*               returns only the DHCP negotiation is completed.
*
* Argument(s) : if_nbr_tbl      Table that contains interface ID to be initialized with uC/DHCPc
*
*               nbr_if_cfgd     Number of interface to initialized (contained in tables)
*
*               if_dhcp_result  Table that will receive the DHCPc result of each interface to initialize.
*
* Return(s)   : DEF_OK,   Completed successfully.
*
*               DEF_FAIL, Initialization failed.
*
* Caller(s)   : Application.
*
* Note(s)     : (1) Prior to do any call to DHCPc the module must be initialized. If the process is successful,
*                   the DHCP client s tasks are started, and its various data structures are initialized.
*
*               (2) It is possible to request additional parameters from the DHCP server by setting a DHCPc options
*                   table, which must be passed to start function. Note that the server will not necessarily
*                   transmit those parameters.
*
*               (3) Start the DHCP management of the interfaces. Note that the interface is not configured yet upon
*                   returning from this function.
*
*               (4) An OS time delay must be applied between each call to DHCP to allow other task to run.
*
*               (5) Once the DHCP management of an interface has been started, the application may want to check the
*                   status of the lease negotiation in order to determine whether or not the interface has been properly
*                   configured:
*
*                   (a) Status DHCP_STATUS_CFG_IN_PROGRESS means that the negotiation is still underway.
*
*                   (b) Status DHCP_STATUS_CFGD indicates that the DHCP negotiation is done and that the interface is
*                       properly configured.
*
*                   (c) Status DHCP_STATUS_CFGD_NO_TMR specifies that the DHCP negotiation is done and that the interface
*                       is properly configured, but no timer has been set for renewing the lease. The effect of this is
*                       that the lease is going to be permanent, even though the server might have set a time limit for it.
*
*                   (d) Status DHCP_STATUS_CFGD_LOCAL_LINK means that the DHCP negotiation was not successful, and that a
*                       link-local address has been attributed to the interface. It is important to note that the DHCP
*                       client will not try to negotiate a lease with a server at this point.
*
*                   (e) Status DHCP_STATUS_FAIL denotes a negotiation error. At this point, the application should call
*                       the DHCPc_Stop() function and decide what to do next.
*
*               (6) Once the DHCP negotiation is completed successfully, it is possible to retrieve the parameters requested
*                   during the start. If the function returns an error an invalid value, it means that the server might have
*                   not transmitted the requested parameters.
*
*               (7) It is possible to retrieve the address configured by the DHCP client by calling the appropriate TCP/IP
*                   stack API.
*********************************************************************************************************
*/

CPU_BOOLEAN  AppDHCPc_Init (NET_IF_NBR      if_nbr,
                            NET_IPv4_ADDR  *p_addr_cfgd,
                            NET_IPv4_ADDR  *p_addr_dns)
{
    DHCPc_STATUS      status;
    CPU_BOOLEAN       done;
    DHCPc_OPT_CODE    req_param[DHCPc_CFG_PARAM_REQ_TBL_SIZE];
    CPU_INT08U        req_param_qty;
    NET_IPv4_ADDR     addr_tbl[NET_IPv4_CFG_IF_MAX_NBR_ADDR];
    NET_IP_ADDRS_QTY  addr_ip_tbl_qty;
    CPU_INT16U        size;
    NET_ERR           err_net;
    DHCPc_ERR         err;

    logf("Configuring DHCPc.\n");

                                                                /* --------------- INITIALIZE uC/DHCPc ---------------- */
    err = DHCPc_Init();                                         /* See Note #1.                                         */
    if (err != DHCPc_ERR_NONE) {
        return (DEF_FAIL);
    }


                                                                /* ---------- CFG DHCPC PARAMETER REQUESTED ----------- */
    req_param[0]   = DHCP_OPT_DOMAIN_NAME_SERVER;               /* Obtain DNS address. See Note #2                      */
    req_param_qty  = 1u;                                        /* 1 parameter requested.                               */


                                                                /* ----------- START DHCPC ON THE INTERFACE ----------- */
    DHCPc_Start(if_nbr, req_param, req_param_qty, &err);        /* See Note #3.                                         */
    if (err != DHCPc_ERR_NONE) {
        return (DEF_FAIL);
    }


                                                                /* ------- WAIT UNTIL NEGOTIATION IS COMPLETED -------- */
    done = DEF_NO;
    while (done == DEF_NO) {
        OSTimeDlyHMSM(0, 0, 0, DHCP_WAIT_MS);
        fprintf(stderr, ".");

        status = DHCPc_ChkStatus(if_nbr, &err);                 /* Check DHCP status. See Note #5.                      */
        switch (status) {
            case DHCP_STATUS_CFG_IN_PROGRESS:                   /* See Note #5a.                                        */
                 break;


            case DHCP_STATUS_CFGD:                              /* See Note #5b.                                        */
            case DHCP_STATUS_CFGD_NO_TMR:                       /* See Note #5c.                                        */
                 size = sizeof(NET_IPv4_ADDR);                  /* An address has been configured.                      */
                 DHCPc_GetOptVal(             if_nbr,           /* Get DNS address obtained by the DHCPc. See Note #6.  */
                                              DHCP_OPT_DOMAIN_NAME_SERVER,
                                (CPU_INT08U *)p_addr_dns,
                                             &size,
                                             &err);
                 /* Break intentionally omitted. */
                 // fall through

            case DHCP_STATUS_CFGD_LOCAL_LINK:                   /* See Note #5d.                                        */
                 done = DEF_YES;
                 addr_ip_tbl_qty = sizeof(addr_tbl) / sizeof(NET_IPv4_ADDR);
                (void)NetIPv4_GetAddrHost(if_nbr,               /* See Note #7. Get current address configured.         */
                                         &addr_tbl[0],
                                         &addr_ip_tbl_qty,
                                         &err_net);
                 if (err_net != NET_IPv4_ERR_NONE) {
                     return (DEF_FAIL);
                 }

                *p_addr_cfgd = addr_tbl[0];
                 break;


            case DHCP_STATUS_FAIL:                              /* See Note #5e. No address has been configured.        */
                 DHCPc_Stop(if_nbr, &err);
                 return (DEF_FAIL);


            default:
                 break;
        }
    }
    fprintf(stderr, "\n");

    logf("Done configuring DHCPc.\n");

    return (DEF_OK);
}

/*******************************************************************************
 * Public Functions
 ******************************************************************************/

CPU_BOOLEAN conf_static(NET_IF_NBR if_nbr, struct network_conf *conf) {
    // Configure IP Address.
    NET_IPv4_ADDR ipv4_addr, ipv4_mask, ipv4_gateway;
    NET_ERR err;

    logf("Configuring (static) IP address\n");
    logf(" * Address: %s\n", conf->ipv4_addr_str);
    logf(" * Mask:    %s\n", conf->ipv4_mask_str);
    logf(" * Gateway: %s\n", conf->ipv4_gateway_str);

    if (!convert_ip_str_to_int(conf->ipv4_addr_str,    &ipv4_addr) ||
        !convert_ip_str_to_int(conf->ipv4_mask_str,    &ipv4_mask) ||
        !convert_ip_str_to_int(conf->ipv4_gateway_str, &ipv4_gateway)) {
        logf("Failed to convert IPv4 string addresses to int array\n");
        return DEF_FALSE;
    }

    CPU_BOOLEAN cfg_success = NetIPv4_CfgAddrAdd(
            if_nbr,
            ipv4_addr,
            ipv4_mask,
            ipv4_gateway,
            &err);
    if (cfg_success != DEF_OK) {
        logf("Failed to add IP address configuration to interface: %d\n",
            err);
        return DEF_FALSE;
    }

    return DEF_TRUE;
}


CPU_BOOLEAN conf_dhcp(NET_IF_NBR if_nbr) {
    NET_IPv4_ADDR addr_cfgd;
    NET_IPv4_ADDR addr_dns;

    if (AppDHCPc_Init(if_nbr, &addr_cfgd, &addr_dns) != DEF_OK) {
        logf("Failed to configure DHCP.\n");
        return DEF_FALSE;
    }

    NET_ERR err;

    CPU_CHAR str_addr_cfgd[NET_ASCII_LEN_MAX_ADDR_IP];
    NetASCII_IPv4_to_Str(addr_cfgd, str_addr_cfgd, DEF_FALSE, &err);
    if (err != NET_ASCII_ERR_NONE) {
        logf("Failed to convert DHCP address to string (%d).\n", err);
        return DEF_FALSE;
    }

    CPU_CHAR str_addr_dns[NET_ASCII_LEN_MAX_ADDR_IP];
    NetASCII_IPv4_to_Str(addr_dns, str_addr_dns, DEF_FALSE, &err);
    if (err != NET_ASCII_ERR_NONE) {
        logf("Failed to convert DHCP DNS address to string (%d).\n", err);
        return DEF_FALSE;
    }

    logf("DHCP info\n");
    logf("* Address: %s.\n", str_addr_cfgd);
    logf("* DNS:     %s.\n", str_addr_dns);

    return DEF_TRUE;
}


CPU_BOOLEAN network_init(struct network_conf *conf, NET_IF_NBR *p_if_nbr) {
    NET_ERR    err_net;

    // uC/TCP-IP generic stack init.
    err_net = Net_Init(
            &NetRxTaskCfg,
            &NetTxDeallocTaskCfg,
            &NetTmrTaskCfg);
    if (err_net != NET_ERR_NONE) {
        logf("Failed to Net_Init(): (%d).\n", err_net);
        return DEF_FALSE;
    }

    // Update TSE sys info struct and MAC address from configuration.
    NetDev_Cfg_Ether_TSE.BaseAddr = (CPU_ADDR) conf->tse_sys_info;

    Mem_Copy(NetDev_Cfg_Ether_TSE.HW_AddrStr, conf->mac_addr,
        sizeof(CPU_CHAR) * NET_IF_802x_ADDR_SIZE_STR);

    // Add TSE.
    *p_if_nbr = NetIF_Add(
            (void *)&NetIF_API_Ether, // const for all eth interfaces
            (void *)&NetDev_API_TSE_mSGDMA_Intel_HAL,
            NULL, // (void *)&Net_DrvBSP_Nios_II,
            (void *)&NetDev_Cfg_Ether_TSE,
            NULL, // (void *)&NetPhy_API_Generic,
            NULL, // (void *)&NetPhy_Cfg_Ether_TSE,
                    &err_net);
    if (err_net != NET_IF_ERR_NONE) {
        logf("Failed to NetIF_Add(): (%d).\n", err_net);
        return DEF_FALSE;
    }

    // Start TSE.
    NetIF_Start(*p_if_nbr, &err_net);
    if (err_net != NET_IF_ERR_NONE){
        logf("Failed to NetIF_Start(): (%d).\n", err_net);
        return DEF_FALSE;
    }

    CPU_BOOLEAN ret;
    if (conf->use_dhcp) {
        ret = conf_dhcp(*p_if_nbr);
    } else {
        ret = conf_static(*p_if_nbr, conf);
    }

    return ret;
}


CPU_BOOLEAN network_stop(NET_IF_NBR if_nbr) {
    for (unsigned attempt = 1; /* stop condition in loop */ ; attempt++) {
        NET_ERR err;

        logf("INFO: Stopping network interface (attempt %d).\n", attempt);

        NetIF_Stop(if_nbr, &err);
        if (err == NET_IF_ERR_NONE) {
            break;
        } else {
            logf(" -> Failed to stop interface with error %d.\n", err);
        }

        KAL_Dly(100);
        attempt++;

        if (attempt > NET_STOP_MAX_TRIES) {
            return DEF_FALSE;
        }
    }
    logf("INFO: Network interface stopped.\n");
    return DEF_TRUE;
}
