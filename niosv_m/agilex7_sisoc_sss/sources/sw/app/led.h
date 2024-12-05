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
// File: led.h
// -----------------------------------------------------------------------------


#ifndef __LED_H__
#define __LED_H__


/*
 * LEDLightshowTask blinks the user LEDs periodically.
 */
void LEDLightshowTask();


/*
 * The LedManagementTask() is a simple uC/OS-II task that controls Nios
 * Development Board LEDs based on commands received by the
 * SSSSimpleSocketServerTask in the SSSLEDCommandQ. 
 *
 * The task will read the SSSLedCommandQ for an 
 * in-coming message command from the SSSSimpleSocketServerTask. 
 */
void LEDManagementTask();


#endif // __LED_H__
