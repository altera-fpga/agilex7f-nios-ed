#include <stdio.h>
#include <system.h>
#include <io.h>
#include <unistd.h>

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include "altera_msgdma_descriptor_regs.h"
#include "altera_msgdma_prefetcher_regs.h"
#include "altera_msgdma_descriptor_regs.h"
#include "altera_msgdma_csr_regs.h"
#include "altera_msgdma.h"
#include "system.h"
#include "os/alt_syscall.h"
#include "sys/alt_log_printf.h"
#include "io.h"
#include "system.h"
#include "altera_avalon_sysid_qsys_regs.h"

typedef uint32_t u32;


#define DATA_DESTINATION_BASE DDR4_EMIF_BASE
#define DATA_SOURCE_BASE INTEL_ONCHIP_MEMORY_1_BASE
#define LEN 256
#define LEN_S 256

// Using usleep as the delay funciton
        int usleep(useconds_t usec);

//Modular Scatter-Gather DMA defines

        alt_msgdma_dev *STDATA_MSGDMA;
        alt_msgdma_dev *dev_ptr;
        alt_msgdma_standard_descriptor STDATA_MSGDMA_DESEC;
        alt_u32 *WRITE_ADDRESS = DATA_DESTINATION_BASE;
        alt_u32 *READ_ADDRESS = DATA_SOURCE_BASE;
        alt_u32 * ram_readaccess_ptr;
        alt_u32 * ram_writeaccess_ptr;
        alt_u32 i,j,first_dma_source_data;
        alt_u32 data_in,data_read;
        alt_32 status=0;

        int *ptr_src_base = (int *)DATA_SOURCE_BASE;



	int main () 
	{
		int a,b,c;
		int i,j;
		int p, p_updated;
		int fail_flag = 0 ;
		int itr = 1 ;
		int sys_id;

		printf("SOURCE_ADDR is : 0x%X \n", DATA_SOURCE_BASE);
		printf("DESTINATION_ADDR is : 0x%X \n", DATA_DESTINATION_BASE);
		printf("Clearing EMIF memory: 0x%X \n",DDR4_EMIF_BASE);

		for(j = 0; j < 32; j=j+4)
        	{
			
		 	p = IORD_32DIRECT(DDR4_EMIF_BASE,j);
                        printf("value at memory location 0x%x with offset %x is 0x%x\n",(DDR4_EMIF_BASE),j, p);
			
			printf("Writing Data Pattern 0x0 \n");
                        IOWR_32DIRECT(DDR4_EMIF_BASE,j,(p & 0x0));
                        p_updated = IORD_32DIRECT(DDR4_EMIF_BASE,j);

			printf("After write: value at memory location 0x%x with offset %x is 0x%x\n",(DDR4_EMIF_BASE),j,p_updated);
		}


#if 0
		for (i =1024 ; i < 1040 ; i=i+4)
		{
			printf("Start Iteration %d\n",itr);
			p = IORD_32DIRECT(DDR4_EMIF_BASE,i);
			printf("value at memory location 0x%x with offset %x is 0x%x\n",(DDR4_EMIF_BASE),i, p);

			printf("Writing Data Pattern 0xa5a5a5a5 \n");
			IOWR_32DIRECT(DDR4_EMIF_BASE,i,0xa5a5a5a5);
			p_updated = IORD_32DIRECT(DDR4_EMIF_BASE,i);

  			printf("After write: value at memory location 0x%x with offset %x is 0x%x\n",(DDR4_EMIF_BASE),i,p_updated);

			if(IORD_32DIRECT(DDR4_EMIF_BASE,i) == 0xa5a5a5a5)
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
#endif
#if 0
		if (fail_flag != 0)
		{
			printf ("EMIF Memory Test Failed\n");
			printf ("EMIF_fail_flag = %d \n",fail_flag);
		}
		else
		{
			printf ("EMIF Memory Test PASSED\n");
		}
#endif

		printf("writing into OCM  memory from NIOS V\n");

        for(j = 0; j < 32; j=j+4)
        {
                /* writing a repeating pattern of 0, 1, .. ,0xFF, ..*/
                data_in = (j & 0xFFFFFFFF);
                IOWR_32DIRECT(DATA_SOURCE_BASE, j, data_in);

                printf("Addr 0x%lx     Data written 0x%lx\n",(DATA_SOURCE_BASE+j), IORD_32DIRECT(DATA_SOURCE_BASE,j));

        }

        printf("Data write to onchip memory completed\n");


		 //Open the mSGDMA
        dev_ptr = alt_msgdma_open(MSGDMA_0_CSR_NAME);
        if (dev_ptr == NULL)
        printf("Could not open mSG-DMA\n");
        printf("DMA is open mSG-DMA\n");
        // Construct the DMA descriptors
        if(alt_msgdma_construct_standard_mm_to_mm_descriptor (
                dev_ptr,
                &STDATA_MSGDMA_DESEC,
                READ_ADDRESS,
                WRITE_ADDRESS,
                LEN,
                ALTERA_MSGDMA_DESCRIPTOR_CONTROL_PARK_WRITES_MASK
                ) == -EINVAL)
                {
                printf(" invalid argument \n");
                goto exit;
                }
                printf("Created descriptor definition for mSG-DMA\n");


        // Run the mSGMA
        status =alt_msgdma_standard_descriptor_async_transfer(dev_ptr, &STDATA_MSGDMA_DESEC);
        printf("status is %x\n",status);

        ALT_USLEEP(100000);
        // verify the data written by the msgdma at the destination addresses //
	printf("DMA moved data to 0x%X DESTINATION ADDRESS \n",DATA_DESTINATION_BASE);
        for(i = 0; i < 32; i=i+4)
        {

                data_read = IORD_32DIRECT(DATA_DESTINATION_BASE,i); // Issue with IORD and IOWR

		ALT_USLEEP(10000);
                printf("Addr 0x%lx     Data read 0x%lx\n",(DATA_DESTINATION_BASE+i), data_read);
                ALT_USLEEP(10000);
                // should be a pattern of 0, 1, .., 0x20, .. 
                printf("base 0x%x offset_add 0x%lx ,expected 0x%lx read 0x%lx\n",DATA_DESTINATION_BASE,i,(i&0xFFFFFFFF), data_read);

                if ((i & 0xFFFFFFFF) != data_read)
                {
                        printf("Error - base 0x%x offset_add 0x%lx failed,expected %lx but read 0x%lx\n" ,DATA_DESTINATION_BASE, i,(i&0xFFFFFFFF), data_read);
                        goto exit;
                } else {
                printf("Data matched !\n");
                }
        }
        printf("Memory copy over DMA was a SUCCESS. Session will now close. \n");

	sys_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE);
        printf ("System ID from Peripheral core is 0x%X \n",sys_id);

        exit:

        printf("%c",(char)4);




		return 0;  
      }


		
