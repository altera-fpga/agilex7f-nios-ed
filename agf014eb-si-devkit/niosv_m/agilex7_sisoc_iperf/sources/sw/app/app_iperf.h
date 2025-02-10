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
// File: app_iperf.h
// -----------------------------------------------------------------------------
//
// IPerf terminal task that will either query for user input or simply run the
// IPerf server.


#ifndef APP_IPERF_H_
#define APP_IPERF_H_

#include <cpu.h>

// Run the IPerf terminal
// @param auto_run_server Don't wait for user input. Automatically run the IPerf server.
void App_IPerf_TaskTerminal(CPU_BOOLEAN auto_run_server);


#endif  // APP_IPERF_H_
