#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "io.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"

int main() {
        // Read acknowledgment value (ack) from PIO 
        unsigned int ack = IORD_ALTERA_AVALON_PIO_DATA(RST_ACK_PIO_BASE);
        
        // Read the ack value and Print Hello world after reset if ack value is 0x03
        if (ack == 0x03) {
                printf("Hello world from Nios V/g cpu after reset\n");
                return 0;
        }
        
        // Wait until ack value is 0x01 to ensure External Supervisor is running
        while ((ack = IORD_ALTERA_AVALON_PIO_DATA(RST_ACK_PIO_BASE)) != 0x01);
        
        // Set ack value to 0x02 (Handshake mechanism with external supervisor)
        IOWR_ALTERA_AVALON_PIO_DATA(RST_ACK_PIO_BASE, 0x02);
        
        // Print Hello world before reset until ack value 0x03
        do {
                printf("Hello world from Nios V/g cpu before reset\n");
                ack = IORD_ALTERA_AVALON_PIO_DATA(RST_ACK_PIO_BASE);
        } while (ack != 0x03);

        // Print Hello world after reset for all other ack values
        printf("Hello world from Nios V/g cpu after reset\n");
	
        return 0;
}