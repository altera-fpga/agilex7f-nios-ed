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
// File: led.c
// -----------------------------------------------------------------------------

/******************************************************************************
 * Includes
 *****************************************************************************/
// Project
#include "led.h"

// Standard Library
#include <stdio.h> // printf()
#include <stdlib.h> // rand()

/* MicroC/OS-II definitions */
#include "includes.h"

/* Device driver accessor macros for peripherial I/O component
 * (used for leds).) */
#include "altera_avalon_pio_regs.h"

/* Simple Socket Server definitions */
#include "simple_socket_server.h"

/* Altera Error Handler suite of development error
 * handling functions. */
#include "alt_error_handler.h"


/******************************************************************************
 * Definitions
 *****************************************************************************/
#define LED_PIO_BASE SYS_LED_PIO_BASE


/******************************************************************************
 * Functions
 *****************************************************************************/


/*
 * led_bit_toggle() sets or clears a bit in led_8_val, which corresponds
 * to 1 of 8 leds, and then writes led_8_val to a register on the Nios
 * Development Board which controls 8 LEDs, D0 - D7.
 *
 */
void led_bit_toggle(INT8U bit)
{
    INT8U led_val;
    #ifdef LED_PIO_BASE
       led_val = IORD_ALTERA_AVALON_PIO_DATA(LED_PIO_BASE);
       led_val = led_val ^ bit;
       IOWR_ALTERA_AVALON_PIO_DATA(LED_PIO_BASE, led_val);
       printf("Value for LED_PIO_BASE set to %d.\n", led_val);
    #endif
}


void LEDLightshowTask()
{
   INT8U error_code;
   INT8U __attribute__ ((unused)) led_val = 0;

   /* This is a task which does not terminate, so loop forever. */
   while(1)
   {
      /* Wait 50 milliseconds between pattern updates, to make the pattern slow
       * enough for the human eye, and more impotantly, to give up control so
       * MicroC/OS-II can schedule other lower priority tasks. */
      OSTimeDlyHMSM(0,0,0,500);

      /* Check that we still have the SSSLEDLightshowSem semaphore. If we don't,
       * then wait until the LEDManagement task gives it back to us. */
      OSSemPend(SSSLEDLightshowSem, 0, &error_code);
      alt_uCOSIIErrorHandler(error_code, 0);

      #ifdef LED_PIO_BASE
         led_val = IORD_ALTERA_AVALON_PIO_DATA(LED_PIO_BASE);
         led_val = led_val ^ 0xF;
         IOWR_ALTERA_AVALON_PIO_DATA(LED_PIO_BASE, led_val);
      #endif

      error_code = OSSemPost(SSSLEDLightshowSem);
      alt_uCOSIIErrorHandler(error_code, 0);
   }
}


void LEDManagementTask()
{

  INT32U led_command;
  BOOLEAN SSSLEDLightshowActive;
  INT8U error_code;

  SSSLEDLightshowActive = OS_TRUE;

  while(1)
  {
    led_command = (INT32U)OSQPend(SSSLEDCommandQ, 0, &error_code);

    alt_uCOSIIErrorHandler(error_code, 0);

    switch (led_command) {
      case CMD_LEDS_BIT_0_TOGGLE:
         led_bit_toggle(BIT_0);
         break;
      case CMD_LEDS_BIT_1_TOGGLE:
         led_bit_toggle(BIT_1);
         break;
      case CMD_LEDS_BIT_2_TOGGLE:
         led_bit_toggle(BIT_2);
         break;
      case CMD_LEDS_BIT_3_TOGGLE:
         led_bit_toggle(BIT_3);
         break;
      case CMD_LEDS_LIGHTSHOW:
         /* The SSSLEDLightshowSem semaphore is checked by LEDLightshowTask
          * each time it updates user LEDs.  Grab the semaphore (pend) away
          * from the lightshow task to toggle the lightshow off, and give up
          * the semaphore (post) to turn the lightshow back on.
          */
         if (SSSLEDLightshowActive == OS_FALSE) {
             error_code = OSSemPost(SSSLEDLightshowSem);
             alt_uCOSIIErrorHandler(error_code, 0);
             SSSLEDLightshowActive = OS_TRUE;
         } else {
             OSSemPend(SSSLEDLightshowSem, 0, &error_code);
             alt_uCOSIIErrorHandler(error_code, 0);
             SSSLEDLightshowActive = OS_FALSE;
         }
         break;
      default:
        /* Discard unknown LED commands. */
        break;
    }
  }
}