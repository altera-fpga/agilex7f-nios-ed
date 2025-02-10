#include <stdio.h>
#include <inttypes.h>
#include "system.h"
#include "altera_avalon_sysid_qsys_regs.h"

// Function to perform various arithmetic and bitwise operations using PE1
void custom_inst_pe_1() {
    uint32_t op;
    printf("************************************************************************* \n");
    printf("PE1 operations \n");
    printf("************************************************************************* \n");
    
    // 1's complement operation
    op = basic_operations(0xff,0,0,0);    
    printf("1's complement of DATA1:0xff \nExpected Output:ffffff00 \nActual Output:%lx \n", op);    

    printf("************************************************************************* \n");   
    // 2's complement operation
    op =basic_operations(0xff,0,1,0);
    printf("2's complement of DATA1:0xff \nExpected Output:ffffff01 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");    
    // Multiplication operation
    op = basic_operations(0x1f,0x80,2,0);
    printf("Multiplication of DATA1:0x1f and DATA2:0x80 \nExpected Output:f80 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Bit reversal operation
    op =basic_operations(0x1f,0x00,3,0);
    printf("Bit Reversal of DATA1:0x1f \nExpected Output:f8000000 \nActual Output:%lx \n", op);
    
    printf("************************************************************************* \n");
    // Byte reversal operation
    op =basic_operations(0x1f, 0x00,4,0);
    printf("Byte Reversal of DATA1:0x1f \nExpected Output:1f000000 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Word reversal operation
    op =basic_operations(0x1f, 0x00,5,0);
    printf("Word Reversal of DATA1:0x1f \nExpected Output:1f0000 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Merging lower dword operation
    op =basic_operations(0x74009078,0x82007083,6,0);
    printf("Merge Lower-dword DATA1:0x74009078 and DATA2:0x82007083 \nExpected Output:90787083 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Merging higher dword operation
    op =basic_operations(0x74009078,0x82007083,7,0);
    printf("Merge Higher-dword of DATA1:0x74009078 and DATA2:0x82007083 \nExpected Output:74008200 \nActual Output:%lx \n", op);
    printf("End of PE1 operations \n");
    printf("************************************************************************* \n");
}

// Function to perform similar operations using PE2
void custom_inst_pe_2() {
    uint32_t op;
    printf("************************************************************************* \n");
    printf("PE2 operations \n");
    printf("************************************************************************* \n");
    
    // 1's complement operation
    op = comp_1s(0xff,0,0);    
    printf("1's complement of DATA1:0xff\nExpected Output:ffffff00 \nActual Output:%lx \n", op);    

    printf("************************************************************************* \n");   
    // 2's complement operation
    op =comp_2s(0xff,0,0);
    printf("2's complement of DATA1:0xff\nExpected Output:ffffff01 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");    
    // Multiplication operation
    op = multiply(0x1f,0x80,0);
    printf("Multiplication of DATA1:0x1f and DATA2:0x80 \nExpected Output:f80 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Bit reversal operation
    op =bit_reversal(0x111fff,0x00,0);
    printf("Bit Reversal of DATA1:0x111fff \nExpected Output:fff88800 \nActual Output:%lx \n", op);
    
    printf("************************************************************************* \n");
    // Byte reversal operation
    op =byte_reversal(0x111fff, 0x00,0);
    printf("Byte Reversal of DATA1:0x111fff \nExpected Output:ff1f1100 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Word reversal operation
    op =word_reversal(0x111fff, 0x00,0);
    printf("Word Reversal of DATA1:0x111fff \nExpected Output:1fff0011 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Merging lower dword operation
    op =merge_lower(0x74009078,0x82007083,0);
    printf("Merge Lower-dword of DATA1:0x74009078 and DATA2:0x82007083 \nExpected Output:90787083 \nActual Output:%lx \n", op);

    printf("************************************************************************* \n");
    // Merging higher dword operation
    op =merge_higher(0x74009078,0x82007083,0);
    printf("Merge Higher-dword of DATA1:0x74009078 and DATA2:0x82007083 \nExpected Output:74008200 \nActual Output:%lx \n", op);
    printf("End of PE2 operations \n");
    printf("************************************************************************* \n");
}

// Main function to execute tests and display system ID
int main() {
    int sys_id;
    printf("Now running custom instruction basic test...\n");
    printf ("Hello world \n");
    custom_inst_pe_1();
    custom_inst_pe_2();
    printf ("Print the value of System ID \n");
    sys_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE);
    printf ("System ID from Peripheral core is 0x%X \n",sys_id);
    printf("Bye world!\n");
    fflush(stdout);
    return 0;
}
