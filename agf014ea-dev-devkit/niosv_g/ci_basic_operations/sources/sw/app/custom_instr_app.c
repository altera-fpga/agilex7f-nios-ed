#include <stdio.h> // Include standard input/output library for printf
#include <inttypes.h> // Include integer types for fixed-width integers
#include "system.h" // Include system-specific definitions
#include "altera_avalon_sysid_qsys_regs.h" // Include definitions for the Altera Avalon SYSID registers

// Function to perform custom instruction operations for processing element 1 (PE1)
void custom_inst_pe_1() {
    uint32_t op; // Declare a variable to hold operation results
    printf("************************************************************************* \n");
    printf("PE1 operations \n"); // Print header for PE1 operations
    printf("************************************************************************* \n");
    
    // Perform 1's complement operation on DATA1:0xff
    op = basic_operations(0xff,0,0,0);    
    printf("1's complement of DATA1:0xff \nExpected Output:ffffff00 \nActual Output:%lx \n", op);    

    printf("************************************************************************* \n");   
    // Perform 2's complement operation on DATA1:0xff
    op =basic_operations(0xff,0,1,0);
    printf("2's complement of DATA1:0xff \nExpected Output:ffffff01 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");    
    // Perform multiplication of DATA1:0x1f and DATA2:0x80
    op = basic_operations(0x1f,0x80,2,0);
    printf("Multiplication of DATA1:0x1f and DATA2:0x80 \nExpected Output:f80 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Perform bit reversal on DATA1:0x1f
    op =basic_operations(0x1f,0x00,3,0);
    printf("Bit Reversal of DATA1:0x1f \nExpected Output:f8000000 \nActual Output:%lx \n", op);
    
    printf("************************************************************************* \n");
    // Perform byte reversal on DATA1:0x1f
    op =basic_operations(0x1f, 0x00,4,0);
    printf("Byte Reversal of DATA1:0x1f \nExpected Output:1f000000 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Perform word reversal on DATA1:0x1f
    op =basic_operations(0x1f, 0x00,5,0);
    printf("Word Reversal of DATA1:0x1f \nExpected Output:1f0000 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Merge lower dword of DATA1:0x74009078 and DATA2:0x82007083
    op =basic_operations(0x74009078,0x82007083,6,0);
    printf("Merge Lower-dword DATA1:0x74009078 and DATA2:0x82007083 \nExpected Output:90787083 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Merge higher dword of DATA1:0x74009078 and DATA2:0x82007083
    op =basic_operations(0x74009078,0x82007083,7,0);
    printf("Merge Higher-dword of DATA1:0x74009078 and DATA2:0x82007083 \nExpected Output:74008200 \nActual Output:%lx \n", op);
    
    printf("End of PE1 operations \n"); // Indicate the end of PE1 operations
    printf("************************************************************************* \n");
}

// Function to perform custom instruction operations for processing element 2 (PE2)
void custom_inst_pe_2() {
    uint32_t op; // Declare a variable to hold operation results
    printf("************************************************************************* \n");
    printf("PE2 operations \n"); // Print header for PE2 operations
    printf("************************************************************************* \n");
    
    // Perform 1's complement operation on DATA1:0xff
    op = comp_1s(0xff,0,0);    
    printf("1's complement of DATA1:0xff\nExpected Output:ffffff00 \nActual Output:%lx \n", op);    

    printf("************************************************************************* \n");   
    // Perform 2's complement operation on DATA1:0xff
    op =comp_2s(0xff,0,0);
    printf("2's complement of DATA1:0xff\nExpected Output:ffffff01 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");    
    // Perform multiplication of DATA1:0x1f and DATA2:0x80
    op = multiply(0x1f,0x80,0);
    printf("Multiplication of DATA1:0x1f and DATA2:0x80 \nExpected Output:f80 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Perform bit reversal on DATA1:0x111fff
    op =bit_reversal(0x111fff,0x00,0);
    printf("Bit Reversal of DATA1:0x111fff \nExpected Output:fff88800 \nActual Output:%lx \n", op);
    
    printf("************************************************************************* \n");
    // Perform byte reversal on DATA1:0x111fff
    op =byte_reversal(0x111fff, 0x00,0);
    printf("Byte Reversal of DATA1:0x111fff \nExpected Output:ff1f1100 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Perform word reversal on DATA1:0x111fff
    op =word_reversal(0x111fff, 0x00,0);
    printf("Word Reversal of DATA1:0x111fff \nExpected Output:1fff0011 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Merge lower dword of DATA1:0x74009078 and DATA2:0x82007083
    op =merge_lower(0x74009078,0x82007083,0);
    printf("Merge Lower-dword of DATA1:0x74009078 and DATA2:0x82007083 \nExpected Output:90787083 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Merge higher dword of DATA1:0x74009078 and DATA2:0x82007083
    op =merge_higher(0x74009078,0x82007083,0);
    printf("Merge Higher-dword of DATA1:0x74009078 and DATA2:0x82007083 \nExpected Output:74008200 \nActual Output:%lx \n", op);
    
    printf("End of PE2 operations \n"); // Indicate the end of PE2 operations
    printf("************************************************************************* \n");
}

// Main function to execute the program
int main() {
    int sys_id; // Declare a variable to hold the system ID
    printf("Now running custom instruction basic test...\n");
    printf ("Hello world \n");
    custom_inst_pe_1(); // Call function for PE1 operations
    custom_inst_pe_2(); // Call function for PE2 operations
    printf ("Print the value of System ID \n");
    sys_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE); // Read system ID from the peripheral
    printf ("System ID from Peripheral core is 0x%X \n",sys_id);
    printf("Bye world!\n");
    fflush(stdout);
    return 0;
}
