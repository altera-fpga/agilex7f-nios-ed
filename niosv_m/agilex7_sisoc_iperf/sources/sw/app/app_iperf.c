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
// File: app_iperf.c
// -----------------------------------------------------------------------------


/******************************************************************************
 * Includes
 *****************************************************************************/

// Project
#include "app_iperf.h"
#include "Reporter/Terminal/iperf_rep.h"
#include "Source/iperf.h"

// Standard Library
#include <stdio.h>
#include <string.h>

// BSP
#include <cpu.h>

/******************************************************************************
 * Definitions
 *****************************************************************************/

#define TASK_TERMINAL_CMD_STR_MAX_LEN (256)

/******************************************************************************
 * Functions
 *****************************************************************************/

void App_OutputFnct (CPU_CHAR        *p_buf,
                     IPERF_OUT_PARAM *p_param __attribute__((unused)))
{
    if (p_buf == (CPU_CHAR *) 0) {
        return;
    }
    printf("%s", p_buf);
}

// Run the IPerf terminal
//  @param auto_run_server Don't wait for user input. Automaticall run the IPerf server.
void App_IPerf_TaskTerminal(CPU_BOOLEAN auto_run_server)
{
    CPU_CHAR        cmd_str[TASK_TERMINAL_CMD_STR_MAX_LEN];
    CPU_INT16S      cmp_str;
    CPU_SIZE_T      cmd_len;
    IPERF_TEST_ID   test_id_iperf;
    IPERF_ERR       err_iperf;


    IPerf_Init(&err_iperf);
    if (err_iperf != IPERF_ERR_NONE) {
        printf("Failed to initialize iperf (%d).\n", err_iperf);
        return;
    }
    printf("\nIPerf Terminal\n\n");

    while (DEF_ON) {
        printf("\n> ");
        if (auto_run_server) {
            // Copy including the NULL character.
            const char *cmd = "iperf -s";
            CPU_SIZE_T cmd_len = Str_Len_N(cmd, TASK_TERMINAL_CMD_STR_MAX_LEN - 1);
            if (cmd_len == (TASK_TERMINAL_CMD_STR_MAX_LEN - 1)) {
                printf("ERROR: IPerf server command too long to fit in buffer.\n");
                return;
            }
            Mem_Copy(cmd_str, cmd, cmd_len + 1); // Include '\0' char.
        } else {
            // Interactive typing input.
            for (size_t i = 0; i < TASK_TERMINAL_CMD_STR_MAX_LEN; i++) {
                char c = (char) fgetc(stdin);
                if (c == '\n') {
                    cmd_str[i] = '\0';
                    putchar('\n');
                    break;
                } else {
                    cmd_str[i] = c;
                    putchar(c);
                }
            }
        }

        // Exit from terminal.
        if (Str_Cmp_N(&cmd_str[0], "exit", 4) == 0) {
            break;
        }

        cmp_str = Str_Cmp_N(&cmd_str[0], "iperf", 5);

        cmd_len = Str_Len(&cmd_str[0]);
        if (cmp_str == 0) {
            printf("\n\n");
            test_id_iperf = IPerf_TestStart( &cmd_str[0],
                                             &App_OutputFnct,
                                              0,
                                             &err_iperf);
            if ((err_iperf     == IPERF_ERR_NONE    ) &&
                (test_id_iperf != IPERF_TEST_ID_NONE)) {
                 IPerf_Reporter((IPERF_TEST_ID    ) test_id_iperf,
                                (IPERF_OUT_FNCT   )&App_OutputFnct,
                                (IPERF_OUT_PARAM *) 0);
                 printf("\n");
            } else {
                printf("IPerf Error %d.\n", err_iperf);
            }
        } else if (cmd_len > 1u) {
                printf("Command is not recognized.");
        }
    }
}
