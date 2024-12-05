// Copyright (C) 2006-2009, 2022 Intel Corporation
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
// File: simple_socket_server.h
// -----------------------------------------------------------------------------

/*
 * Simple Socket Server (SSS) example.
 *
 * Software Design Methodology Note:
 *
 * The naming convention used in the Simple Socket Server Tutorial employs
 * capitalized software module references as prefixes to variables to identify
 * public resources for each software module, while lower-case
 * variables with underscores indicate a private resource used strictly
 * internally to a software module.
 *
 * The software modules are named and have capitalized variable identifiers as
 * follows:
 *
 * SSS      Simple Socket Server software module
 * LED      Light Emitting Diode Management software module
 * NETUTILS Network Utilities software module
 *
 * OS       Micrium MicroC/OS-II Real-Time Operating System software component
 */

 /* Validate supported Software components specified on system library properties page.
  */
#ifndef __SIMPLE_SOCKET_SERVER_H__
#define __SIMPLE_SOCKET_SERVER_H__

#include "led.h"

#if !defined (__UC_TCP_IP__)
  #error The Simple Socket Server example requires the uC/TCP-IP software package.
#endif

#ifndef __ucosii__
  #error This Simple Socket Server example requires
  #error the MicroC/OS-II Intellectual Property Software Component.
#endif

/*
 * Task Prototypes:
 *
 *    SSSSimpleSocketServerTask() - Manages the socket server connection and
 * calls relevant subroutines to manage the socket connection.
 *
 *    SSSInitialTask() instantiates all of the MicroC/OS-II resources.
 *
 */

void SSSCreateOSDataStructs();
void SSSCreateTasks();
void SSSSimpleSocketServerTask();

/*
 *  Task Priorities:
 *
 *  MicroC/OS-II only allows one task (thread) per priority number.
 */
#define LED_MANAGEMENT_TASK_PRIORITY            7
#define LED_LIGHTSHOW_TASK_PRIORITY             18
#define SSS_SIMPLE_SOCKET_SERVER_TASK_PRIORITY  10
#define SSS_INITIAL_TASK_PRIORITY               5

/*
 * IP Port(s) for our application(s)
 */
#define SSS_PORT 80

/* Definition of Task Stack size for non-uC/TCP-IP tasks */
#define   TASK_STACKSIZE       2048

/*
 * Defined commands for the sss server to interpret
 */
#define CMD_LEDS_BIT_0_TOGGLE   '0'
#define CMD_LEDS_BIT_1_TOGGLE   '1'
#define CMD_LEDS_BIT_2_TOGGLE   '2'
#define CMD_LEDS_BIT_3_TOGGLE   '3'
#define CMD_LEDS_BIT_4_TOGGLE   '4'
#define CMD_LEDS_BIT_5_TOGGLE   '5'
#define CMD_LEDS_BIT_6_TOGGLE   '6'
#define CMD_LEDS_BIT_7_TOGGLE   '7'
#define CMD_LEDS_LIGHTSHOW      'S'
#define CMD_QUIT                'Q'

/*
 * Bit Masks for LED Toggles
 */
#define BIT_0 0x1
#define BIT_1 0x2
#define BIT_2 0x4
#define BIT_3 0x8
#define BIT_4 0x10
#define BIT_5 0x20
#define BIT_6 0x40
#define BIT_7 0x80

/*
 * TX & RX buffer sizes for all socket sends & receives in our sss app
 */
#define SSS_RX_BUF_SIZE  1500
#define SSS_TX_BUF_SIZE  1500

/*
 * Here we structure to manage sss communication for a single connection
 */
typedef struct SSS_SOCKET
{
  enum { READY, COMPLETE, CLOSE } state;
  int       fd;
  int       close;
  INT8U     rx_buffer[SSS_RX_BUF_SIZE];
  INT8U     *rx_rd_pos; /* position we've read up to */
  INT8U     *rx_wr_pos; /* position we've written up to */
} SSSConn;

/*
 * Handles to our MicroC/OS-II resources. All of the resources beginning with
 * "SSS" are declared in file "simple_socket_server.c".
 */

/*
 * Handle to our MicroC/OS-II Command Queue for sending commands received
 * on the TCP-IP socket from the SSSSimpleSocketServerTask to the LEDTask.
 */
extern OS_EVENT *SSSLEDCommandQ;

/*
 * Handle to our MicroC/OS-II LED Event Flag.  Each flag corresponds to one of
 * the LEDs on the Nios Development board, D0 - D7.
 */
extern OS_FLAG_GRP *SSSLEDEventFlag;

/*
 * Handle to our MicroC/OS-II LED Lightshow Semaphore. The semaphore is checked
 * by the SSSLEDLightshowTask each time it updates user LEDs, The LEDTask grabs
 * the semaphore away from the lightshow task to toggle the lightshow off, and
 * gives up the semaphore to turn the lightshow back on.  The LEDTask does this
 * in response to the CMD_LEDS_LIGHTSHOW command sent from the
 * SSSSimpleSocketServerTask when user sends the toggle lightshow command over
 * the TCP/IP socket.
 */
extern OS_EVENT *SSSLEDLightshowSem;

#endif /* __SIMPLE_SOCKET_SERVER_H__ */
