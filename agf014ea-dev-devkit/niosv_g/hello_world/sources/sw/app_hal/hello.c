/*
 * Copyright (C) 2021 Intel Corporation
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <stdio.h>
#include <unistd.h>
#include "io.h"
#include "system.h"
#include "altera_avalon_sysid_qsys_regs.h"


void looper() {
    for (int i = 0; i < 100; ++i) {
        printf("Hello world, this is the Nios V/g cpu checking in %d...\n", i);
    }
}

int main() {

	int sys_id;	
	looper();
	usleep(1000);

	printf ("Print the value of System ID \n");
	sys_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE);
	printf ("System ID from Peripheral core is 0x%X \n",sys_id);
	

	printf("Bye world!\n");
	return 0;
}
