#include <stdio.h>
#include <stdint.h>
#include "io.h"
#include <unistd.h>
#include <system.h>
#include "altera_avalon_pio_regs.h"
 
typedef uint32_t u32;
 
// Define base addresses for On-Chip Memory and System ID
#define OCM_BASE INTEL_ONCHIP_MEMORY_0_BASE
#define SYS_ID_BASE SYSID_QSYS_0_BASE 
 
// Function prototype for usleep (used for delay)
int usleep(useconds_t usec);
 
// Function to toggle the PIO (Parallel I/O) registers and verify data integrity
int pio()
{
    int count = 0; // Counter variable for toggling PIO values
    int i;         // Temporary variable for bit-masking
    int pio_err = 0; // Error counter for PIO mismatches
    
    printf("Application to toggle the PIOs- [4:0] \n");

    // Loop to toggle PIO values and check readback
    while(count < 64)
    {
        i = count & 0xf; // Mask lower 4 bits of count
        IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE, count & 0xf); // Write to PIO register
        usleep(100); // Small delay for stability
        
        // Read back data from PIO register
        printf("DATA READBACK FROM PIO_0_BASE is 0x%x \n", IORD_ALTERA_AVALON_PIO_DATA(PIO_0_BASE));

        // Verify if written data matches the readback data
        if (i != IORD_ALTERA_AVALON_PIO_DATA(PIO_0_BASE))
        {
            printf("Data MISMATCH - TEST FAILED \n");
            pio_err++; // Increment error count
        }
        else
        {
            printf("DATA MATCHED - TEST PASSED \n");
        }
        count++; // Increment count for next iteration
    }
    return pio_err; // Return the number of errors encountered
}
 
// Main function
int main()
{
    int p;                 // Variable for memory read
    int p_updated;         // Variable for memory write verification
    int sys_id;            // Variable to store System ID
    int i;                 // Loop iterator for memory test
    int pio_fail_flag;     // Flag to check PIO test result
    
    printf("Hello World \n");
    printf("Application will execute Memory Test & PIO toggle test \n");
 
    // Memory test
    printf("Starting Memory test \n");
    for (i = 0; i < 32; i += 4)
    {
        p = IORD_32DIRECT(OCM_BASE, i); // Read memory value at offset i
        printf("Value at memory location 0x%x with offset %d is 0x%x\n", OCM_BASE, i, p);

        IOWR_32DIRECT(OCM_BASE, i, 0xa5a5a5a5); // Write test pattern
        p_updated = IORD_32DIRECT(OCM_BASE, i); // Read back the written value
        printf("After write: Value at memory location 0x%x with offset %d is 0x%x\n", OCM_BASE, i, p_updated);
        
        // Verify if memory write was successful
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
 
    // PIO register toggle test
    printf("PIO Test Start: Toggle PIO registers \n");
    pio_fail_flag = pio(); // Call PIO test function
    
    // Check the result of PIO test
    if (pio_fail_flag != 0)
    {
        printf("NIOSV-PIO Test failed with PIO_ERR = %d\n", pio_fail_flag);
    }
    else
    {
        printf("NIOSV-PIO Test PASSED \n");
    }
 
    // Read and check System ID
    printf("Readback and check System ID Peripheral Core value \n");
    sys_id = IORD_32DIRECT(SYS_ID_BASE, 0); // Read System ID register
    if (sys_id == 0xA5)
    {
        printf("SYS ID matched with hardware with value 0x%X\n", sys_id);    
    }
 
    return 0;
}
