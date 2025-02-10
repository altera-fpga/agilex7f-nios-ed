/*
 * Copyright (C) 2021 Intel Corporation
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <stdio.h>
#include <unistd.h>
#include "io.h"
#include "system.h"
#include "altera_avalon_sysid_qsys_regs.h"

// Function to print a message repeatedly
void looper() {
    for (int i = 0; i < 10000; ++i) {
        printf("Hello world, this is the Nios V/g cpu checking in %d...\n", i);
    }
}

int main() {
    int sys_id;
    
    // Run the looper function to print messages
    looper();
    
    // Introduce a short delay before reading System ID
    usleep(1000);

    // Read and print the System ID from the peripheral core
    printf ("Print the value of System ID \n");
    sys_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE); // Read System ID from the Qsys system ID peripheral
    printf ("System ID from Peripheral core is 0x%X \n", sys_id);
    
    printf("Bye world!\n");
    return 0;
}
