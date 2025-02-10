//----------------------------------------------------------------------------------------------------------
// Copyright (C) 2021-2022 Intel Corporation
// 
// This code and the related documents are Intel copyrighted materials, and 
// your use of them is governed by the express license under which they were 
// provided to you ("License"). Unless the License provides otherwise, you may 
// not use, modify, copy, publish, distribute, disclose or transmit this 
// code or the related documents without Intel's prior written permission.
//
// This code and the related documents are provided as is, with no express 
// or implied warranties, other than those that are expressly stated in the 
// License.
//
//----------------------------------------------------------------------------------------------------------

/* Input functions */

#include <stdio.h>
#include "system.h"
#include "string.h"
#include "altera_avalon_pio_regs.h"
#include <unistd.h>
#include "io.h"
#include "altera_avalon_jtag_uart_regs.h" 

#include "parameters.h"

/*-----------------------------------------------
 * input_char()
 * 
 * Gets a single input char for menu prompt
 * 
 *   ******** Added by Guy for Menu inputs
 *   ******** Changed by Maurizio for Nios II SDK Shell support
 * 
 * ----------------------------------------------*/
//char input_char(void)
// {
// char in_char, rx_char;
// 
//   rx_char = 0;
//   while (1)
//   {
//     in_char = getchar();
//     if (in_char != '\r' && in_char != '\n')
//         rx_char = in_char;
//     else if (in_char == '\n')
//         break;
//   };
// printf("%c",rx_char);
// return (rx_char);
// }
 

// Note old code above relies om '\r' to signify the enter key.  
// This is true for Linux systems and Cygwin.  
// In 15.0 we broke our dependence on Cygwin and now we use Microsoft Visual Studio for the compiler.  
// It produces \n in response to a enter key which is standard for a windows machine.  
// So rewriting the input_char() as follows should fix all the input problems, regardless of OS.  
// With this fix it will work for all version of nios2-terminal.
 
char input_char(void)
{
char in_char, rx_char;

rx_char = 0;
char prev = 0;
while (1)
{
	in_char = getchar();
	if (in_char != '\r' && in_char != '\n')
		rx_char = in_char;
	else if ((in_char == '\n' && prev != '\r') || (in_char == '\r' && prev != '\n')) 
		break; 
  prev = in_char;

}
if (NIOS_TERMINAL_19_1) 
	printf("%c",rx_char);

return (rx_char);
}


int input_number(void)
 {
 char in_char,LSB;
 char prev = 0;
 int temp, number;
 
   LSB = 0;
   temp = 0;
   number = 0;
   while (1)
   {
     in_char = getchar();
     if (in_char != '\r' && in_char != '\n')
        {
         //rx_char = in_char;        
         LSB = in_char;
        }
     else if ((in_char == '\n' && prev != '\r') || (in_char == '\r' && prev != '\n'))
         break;
     prev = in_char;
     
            switch (LSB)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
         
    
          number  = temp;         
   };
if (NIOS_TERMINAL_19_1) 
	printf("%x",number);	

 return (number);
 } 
 
int input_byte(void)
 {
 char in_char, MSB,LSB;
 char prev = 0;
 int temp, High_nibble, Low_nibble, Byte;
	 
 
   MSB = 0;
   LSB = 0;
   temp = 0;
   Byte = 0;
   while (1)
   {
     in_char = getchar();
     if (in_char != '\r' && in_char != '\n')
        {
         //rx_char = in_char;
         MSB = LSB;         
         LSB = in_char;
        }
     else if ((in_char == '\n' && prev != '\r') || (in_char == '\r' && prev != '\n'))
         break;
	  prev = in_char;
	  
     switch (MSB)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          High_nibble = temp;
          
            switch (LSB)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          Low_nibble = temp;  
    
          Byte = (High_nibble << 4) | Low_nibble;         
   };
if (NIOS_TERMINAL_19_1) 	
	printf("%2x",Byte);	

 return (Byte);
 } 

int input_double(void)
 {
 char in_char, MSB,LSB;
 char prev = 0;	 
 int temp, High_nibble, Low_nibble, Double_Digit;
 
   MSB = 0;
   LSB = 0;
   temp = 0;
   Double_Digit = 0;
   while (1)
   {
     in_char = getchar();
     if (in_char != '\r' && in_char != '\n')
        {
         //rx_char = in_char;
         MSB = LSB;         
         LSB = in_char;
        }
     else if ((in_char == '\n' && prev != '\r') || (in_char == '\r' && prev != '\n'))
         break;
	  prev = in_char;
	  
     switch (MSB)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            default : break;
            }
          
          High_nibble = temp;
          
            switch (LSB)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            default : break;
            }
          
          Low_nibble = temp;  
    
          Double_Digit = (High_nibble *10) + Low_nibble;         
   };
if (NIOS_TERMINAL_19_1) 
	printf("%2d",Double_Digit);	

 return (Double_Digit);

 } 
 
 
int input_word(void)
 {
 char in_char, N3,N2,N1,N0;
 char prev = 0;		 
 int temp, N3_int, N2_int,N1_int,N0_int, Word;
 
   N3 = 0;
   N2 = 0;
   N1 = 0;
   N0 = 0;         
   temp = 0;
   Word = 0;
   while (1)
   {
     in_char = getchar();
     if (in_char != '\r' && in_char != '\n')
        {
         //rx_char = in_char;
         N3 = N2;
         N2 = N1;
         N1 = N0;
         N0 = in_char;
        }
     else if ((in_char == '\n' && prev != '\r') || (in_char == '\r' && prev != '\n'))
         break;
	  prev = in_char;
	  
     switch (N3)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N3_int = temp;
          
         switch (N2)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N2_int = temp;  

         switch (N1)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N1_int = temp;  

         switch (N0)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N0_int = temp;                
          Word = (N3_int << 12) | (N2_int << 8) | (N1_int << 4) | N0_int;         
   };
if (NIOS_TERMINAL_19_1) 	
	printf("%4x",Word);		

 return (Word);

 	
 } 
 
 unsigned int input_double_word(void)
 {
 char in_char, N7,N6,N5,N4,N3,N2,N1,N0;
 char prev = 0;		 
 int temp, N7_int, N6_int, N5_int, N4_int, N3_int, N2_int,N1_int,N0_int;
 unsigned int DoubleWord;

   N7 = 0;
   N6 = 0;
   N5 = 0;
   N4 = 0; 
   N3 = 0;
   N2 = 0;
   N1 = 0;
   N0 = 0;         
   temp = 0;
   DoubleWord = 0;
	
   while (1)
   {
     in_char = getchar();
     if (in_char != '\r' && in_char != '\n')
        {
         //rx_char = in_char;
         N7 = N6;			
         N6 = N5;
         N5 = N4;
         N4 = N3;			
         N3 = N2;
         N2 = N1;
         N1 = N0;
         N0 = in_char;
        }
     else if ((in_char == '\n' && prev != '\r') || (in_char == '\r' && prev != '\n'))
         break;
	  prev = in_char;
	  
     switch (N7)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N7_int = temp;

     switch (N6)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N6_int = temp;

     switch (N5)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N5_int = temp;

     switch (N4)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N4_int = temp;
			 
	  
     switch (N3)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N3_int = temp;
          
         switch (N2)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N2_int = temp;  

         switch (N1)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N1_int = temp;  

         switch (N0)
            {
            case '0': temp = 0; break;
            case '1': temp = 1; break;
            case '2': temp = 2; break;
            case '3': temp = 3; break;
            case '4': temp = 4; break;
            case '5': temp = 5; break;
            case '6': temp = 6; break;
            case '7': temp = 7; break;
            case '8': temp = 8; break;
            case '9': temp = 9; break;
            case 'A': 
            case 'a': temp = 0xa; break;
            case 'B': 
            case 'b': temp = 0xb; break;
            case 'C': 
            case 'c': temp = 0xc; break;
            case 'D': 
            case 'd': temp = 0xd; break;
            case 'E': 
            case 'e': temp = 0xe; break;
            case 'F': 
            case 'f': temp = 0xf; break;
            default : break;
            }
          
          N0_int = temp;                
          DoubleWord = (N7_int << 28) | (N6_int << 24) | (N5_int << 20) | (N4_int << 16) | (N3_int << 12) | (N2_int << 8) | (N1_int << 4) | N0_int;         
   };
if (NIOS_TERMINAL_19_1) 	
	printf("0%x",DoubleWord);		

 return (DoubleWord);

 	
 } 
 