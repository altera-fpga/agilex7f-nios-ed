/*
 * Copyright (C) 2021 Intel Corporation
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <stdio.h> // Standard I/O functions
#include <unistd.h> // Standard library for usleep function
#include "io.h" // I/O functions for memory-mapped I/O
#include "system.h" // System definitions
#include "altera_avalon_sysid_qsys_regs.h" // Altera Avalon SysID Qsys register definitions

// Function to print "Hello world" messages in a loop
void looper() {
    for (int i = 0; i < 10000; ++i) { // Loop 10000 times
        printf("Hello world, this is the Nios V/g cpu checking in %d...\n", i); // Print message with loop counter
    }
}

int main() {
    int sys_id; // Variable to store system ID

    looper(); // Call the looper function
    usleep(1000); // Sleep for 1000 microseconds

    printf("Print the value of System ID \n"); // Print message before reading system ID
    sys_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE); // Read system ID
    printf("System ID from Peripheral core is 0x%X \n", sys_id); // Print system ID

    printf("Bye world!\n"); // Print goodbye message
    return 0; // Exit the application
}
