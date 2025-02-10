#include <stdio.h>
#include <stdint.h>
#include "io.h"
#include <unistd.h>
#include <system.h>
#include "altera_avalon_pio_regs.h"

typedef uint32_t u32;


#define OCM_BASE INTEL_ONCHIP_MEMORY_0_BASE
#define SYS_ID_BASE SYSID_QSYS_0_BASE 


int usleep(useconds_t usec);


        int pio ()
        {


                int count = 0;
                int i;
                int pio_err = 0;
                printf("Application to toggle the PIOs- [4:0] \n");

                while(count < 64)
                {
                        i = count&0xf;
                        IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE,count&0xf);
                        usleep(100);
                        printf("DATA READBACK FROM PIO_0_BASE is 0x%x \n",IORD_ALTERA_AVALON_PIO_DATA(PIO_0_BASE));

                        if (i != IORD_ALTERA_AVALON_PIO_DATA(PIO_0_BASE))
                        {

                                printf("Data MISMATCH - TEST FAILED \n");
                                pio_err = pio_err + 1;
                        }
                        else
                        {
                                printf ("DATA MATCHED - TEST PASSED \n");
                        }
                count++;
                }
		return pio_err;


        }





int main()

{
	int p;
	int p_updated;
	int sys_id;
	int i;
	int pio_fail_flag;
	printf ("Hello World \n");
	printf ("Application will execute Memory Test & PIO toggle test \n");


	printf("Starting Memory test \n");


	for (i =0 ; i < 32 ; i=i+4)
	{
		p=IORD_32DIRECT(OCM_BASE,i);
		printf("value at memory location 0x%x with offset %d is 0x%x\n",OCM_BASE,i, p);

		IOWR_32DIRECT(OCM_BASE,i,0xa5a5a5a5);
		p_updated = IORD_32DIRECT(OCM_BASE,i);
		printf("After write: value at memory location 0x%x with offset %d is 0x%x\n",OCM_BASE,i, p_updated);
		
		if(p_updated == 0xa5a5a5a5)
		{	
			printf("Memory write test PASSED\n");
		}
		else
		{
			printf("Memory write test FAILED\n");
		}
	}
	
	printf("Memory Test Complete \n");

	printf("PIO Test Start: Toggle PIO registers \n");
	
	


        pio_fail_flag = pio();
	if ((pio_fail_flag != 0)  )
        {

		printf ("NIOSV-PIO Test failed with PIO_ERR = %d\n",pio_fail_flag);
        }
        else
        {
		printf ("NIOSV-PIO Test PASSED \n");
        }


	
	printf("Readback and check System ID Peripheral Core value \n");
	// Print and check the SYS ID contents
	sys_id = IORD_32DIRECT(SYS_ID_BASE,0);
	if (sys_id == 0xA5)
	{
		printf("SYS ID matched with hardware with value 0x%X",sys_id);	
	}	



return 0;
}
