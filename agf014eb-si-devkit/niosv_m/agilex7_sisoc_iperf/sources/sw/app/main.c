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
// File: main.c
// -----------------------------------------------------------------------------
//
// Running uC/IPerf to test network performance of TSE + mSGDMA. Note that
// uC/IPerf is based on and works with IPerf2.

/******************************************************************************
 * Includes
 *****************************************************************************/

// Project
#include "uc_tcp_ip_init.h"
#include "app_iperf.h"
#include "log.h"
#include "altera_avalon_sysid_qsys_regs.h"

// Standard Library
#include <inttypes.h>
#include <stdio.h>

// BSP
#include <includes.h>
#include <altera_avalon_tse.h>             // MAXNETS
#include <altera_avalon_tse_system_info.h> // tse_sys_info creation macros
#include <sys/alt_exceptions.h>
#include <sys/alt_timestamp.h>

/******************************************************************************
 * Definitions
 *****************************************************************************/

/* Definition of Task Stacks */
#define MAIN_TASK_STACKSIZE (4096u)
static OS_STK main_stk[MAIN_TASK_STACKSIZE];

/* Definition of Task Priorities */
static const unsigned MAIN_TASK_PRIORITY = 6u;

/******************************************************************************
 * Functions
 *****************************************************************************/

// Requirement: Must be called 'tse_mac_device' due to the altera avalon TSE
// BSP code relying on this variable name via an 'extern'.
//
// Note that the macro ends the struct init with a comma, so we require 'list
// style' init.
alt_tse_system_info tse_mac_device[MAXNETS] = {
    TSE_SYSTEM_EXT_MEM_NO_SHARED_FIFO(
        SYS_TSE,              // tse_name
        0,                    // offset
        SYS_TSE_MSGDMA_TX,    // msgdma_tx_name
        SYS_TSE_MSGDMA_RX,    // msgdma_rx_name
        TSE_PHY_AUTO_ADDRESS, // phy_addr
        NULL,                 // phy_cfg_fp
        SYS_DESC_MEM          // desc_mem_name
    )
};


void uc_main_task(void *task_data __attribute__((unused))) {
    logf("\n");
    logf("==============================================================\n");
    logf("                      uC/TCP-IP Setup\n");
    logf("==============================================================\n");

    alt_tse_system_info *tse_sys_info = &(tse_mac_device[0]);

    logf("TSE MAC base: 0x%" PRIx32 ".\n", tse_sys_info->tse_mac_base);
    logf("Rx csr name: %s.\n",  tse_sys_info->tse_msgdma_rx);
    logf("Tx csr name: %s.\n",  tse_sys_info->tse_msgdma_tx);

    struct network_conf conf = {
        .tse_sys_info = tse_sys_info,

        .mac_addr = "00:07:ed:ff:8c:05",

        .use_dhcp = !DEF_TRUE,

        // Note, unused if use_dhcp is true.
        .ipv4_addr_str    = "192.168.1.100",
        .ipv4_mask_str    = "255.255.255.0",
        .ipv4_gateway_str = "192.168.1.254"
    };
    NET_IF_NBR if_nbr;

    // Initialize the network stack.
    logf("INFO: Initializing network stack.\n");
    if (!network_init(&conf, &if_nbr)) {
        logf("INFO: Initializing network stack: Failed.\n");
        OSTaskDel(OS_PRIO_SELF);
    }
    logf("INFO: Initializing network stack: Success. Using interface %d.\n", if_nbr);

    App_IPerf_TaskTerminal(
        1 // Automatically run the server without waiting for user input.
    );

    logf("INFO: And we're done!\n");

    for (int try = 0; /* stop condition in loop */ ; try++) {
        NET_ERR err;

        logf("INFO: Stopping network interface (try %d).\n", try);

        NetIF_Stop(if_nbr, &err);
        if (err == NET_IF_ERR_NONE) {
            break;
        } else {
            logf(" -> Failed to stop interface with error %d.\n", err);
        }

        KAL_Dly(10);
        try++;
    }
    logf("INFO: Network interface stopped.\n");

    // This task is deleted because there is no need for it to run again.
    OSTaskDel(OS_PRIO_SELF);

    // Correct Program Flow should never get here.
    while (1) {
        logf("ERROR: Should not be here, task should be deleted.");
    }
}

alt_exception_result instr_exception_handler(alt_exception_cause cause,
    alt_u32 epc, alt_u32 tval) {
    printf("Instruction exception!\n");
    printf(" * cause: %d\n", cause);
    printf(" * epc:   0x%" PRIx32 "\n", epc);
    printf(" * tval:  0x%" PRIx32 "\n", tval);

    while (1) {};

    return NIOSV_EXCEPTION_RETURN_REISSUE_INST;
}

/* The main function which starts the main task and starts multi-tasking. */
int main(void) {
	int sys_id;
    alt_instruction_exception_register (instr_exception_handler);

    /* turn off buffering */
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);

    CPU_TS_TmrFreqSet(alt_timestamp_freq());
    CPU_TS_TmrInit();

    logf("Main Task TOS: %p\n", main_stk);

    INT8U err = OSTaskCreateExt(uc_main_task,
            NULL, (void *) &main_stk[MAIN_TASK_STACKSIZE - 1],
            MAIN_TASK_PRIORITY,
            MAIN_TASK_PRIORITY, main_stk,
            MAIN_TASK_STACKSIZE,
            NULL, 0);
    if (err != OS_ERR_NONE) {
        logf("Failed to create main task (%d).\n", err);
    }
	
	printf ("Print the value of System ID \n");
	sys_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYS_SYSID_BASE);
	printf ("System ID from Peripheral core is 0x%X \n",sys_id);
	
    OSStart();
    return 0;
}
