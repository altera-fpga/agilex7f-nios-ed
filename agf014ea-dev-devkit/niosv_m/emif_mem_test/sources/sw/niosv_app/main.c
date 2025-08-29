#include <stdio.h>
#include <system.h>
#include <io.h>
#include <unistd.h>
#include "altera_avalon_sysid_qsys_regs.h"

// Using usleep as the delay funciton
        int usleep(useconds_t usec);

#define EMIF_FM_0_BASE EMIF_FM_0_ARCH_BASE

	int main () 
	{
		int a,b,c;
		int i;
		int p, p_updated;
		int fail_flag = 0 ;
		int itr = 1 ;
		int sys_id;

		printf("Hello World ! Memory test exercising EMIF memory: 0x%X \n",EMIF_FM_0_BASE);

	
		for (i =1024 ; i < 1040 ; i=i+1)
		{
			printf("Start Iteration %d\n",itr);
			p = IORD(EMIF_FM_0_BASE,i);
			printf("value at memory location 0x%x with offset %x is 0x%x\n",(EMIF_FM_0_BASE),i, p);

			printf("Writing Data Pattern 0xa5a5a5a5 \n");
			IOWR(EMIF_FM_0_BASE,i,0xa5a5a5a5);
			p_updated = IORD(EMIF_FM_0_BASE,i);

  			printf("After write: value at memory location 0x%x with offset %x is 0x%x\n",(EMIF_FM_0_BASE),i,p_updated);

			if(IORD(EMIF_FM_0_BASE,i) == 0xa5a5a5a5)
			{
				printf("Memory test PASSED in iteration : %d\n",itr);
			}
			else
			{
				printf("Memory test FAILED in iteration : %d\n",itr);
				fail_flag = fail_flag + 1;
			}
			itr++;
		}

		if (fail_flag != 0)
		{
			printf ("EMIF Memory Test Failed\n");
			printf ("EMIF_fail_flag = %d \n",fail_flag);
		}
		else
		{
			printf ("EMIF Memory Test PASSED\n");
		}

		sys_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE);
                printf ("System ID from Peripheral core is 0x%X \n",sys_id);


		return 0;  
      }


		
