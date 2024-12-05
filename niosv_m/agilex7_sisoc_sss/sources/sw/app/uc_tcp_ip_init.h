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
// File: uc_tcp_ip_init.h
// -----------------------------------------------------------------------------
//
// Network stack init with either static addressing or DHCP (uC-DHCPc).

#ifndef UC_TCP_IP_INIT_H_
#define UC_TCP_IP_INIT_H_

/*******************************************************************************
 * Includes
 ******************************************************************************/

#include <uc_tcp_ip.h> // From uC/TCP-IP software package.

/*******************************************************************************
 * Structures and Definitions
 ******************************************************************************/

// If use_dhcp is true, then "Static IP configuration" fields will be unused.
struct network_conf {
    // The TSE system info struct.
    alt_tse_system_info *tse_sys_info;

    // The hardware address string.
    CPU_CHAR mac_addr[NET_IF_802x_ADDR_SIZE_STR];

    // Acquire address via DHCP?
    CPU_BOOLEAN use_dhcp;

    // Static IP configuration.
    CPU_CHAR *ipv4_addr_str;
    CPU_CHAR *ipv4_mask_str;
    CPU_CHAR *ipv4_gateway_str;
};

/*******************************************************************************
 * Functions
 ******************************************************************************/

/**
 * Initialize the network stack and the triple speed ethernet.
 * See uC_TCP-IP/Examples/Init/init_ether.c
 *
 * @param  conf[in]       Network configuration such as IPv4 addresses or DHCP usage.
 * @param  p_if_nbr[out]  What is the interface we have configured?
 */
CPU_BOOLEAN network_init(struct network_conf *conf, NET_IF_NBR *p_if_nbr);


/**
 * Stop the triple speed ethernet network interface.
 *
 * @param  if_nbr[in]  What is the interface that needs to be stopped.
 */
CPU_BOOLEAN network_stop(NET_IF_NBR if_nbr);

#endif /* UC_TCP_IP_INIT_H_ */
