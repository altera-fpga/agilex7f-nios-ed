#include <stdio.h>
#include <unistd.h>
#include "io.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_sysid_qsys_regs.h"
#define LOCKSTEP_CONFIG_BASE_ADDR 0x00060000 // Lockstep Base Address

// usleep definition
int usleep(useconds_t usec);

// Alarm Detection function
void alarm_detection(){
    /*
    * Detection mechanism
    * 1. Read Alarms (Expecting no alarms)
    * 2. Read fRSmartComp state (Expecting OD state)
    * 3. Read mismatch slice (Expecting no mismatch)
    */
    usleep(100000);
    //Reading Alarms (ERRCTRL_FNGIALARMS) 
    unsigned int read_alarm = IORD_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD498);
    //Reading fRSmartComp state (ERRCTRL_FNPERIPHGI4)
    unsigned int read_state = IORD_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD4E4);
    //Reading Mismatch Comparator Slices (ERRCTRL_FNGICMPCTXT0)
    unsigned int read_slice = IORD_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD4B0);

    printf("****Reading Alarms, System & Comp State****\n");
    if(!read_alarm)
    {
        printf("No Alarms Detected\n");
    }
    else
    {
        if(read_alarm&0x1) printf("Alarm0\n");
        if(read_alarm&0x2) printf("Alarm1\n");
        if(read_alarm&0x4) printf("Alarm2\n");
        if(read_alarm&0x8) printf("Alarm3\n");
        if(read_alarm&0x10) printf("Alarm4\n");
        if(read_alarm&0x10000) printf("Alarm16\n");
        if(read_alarm&0x20000) printf("Alarm17\n");
        if(read_alarm&0x80000) printf("Alarm19\n");
    }
 
    switch(read_state)
    {
        case 0x1: printf("DISABLED\n"); break;
        case 0x2: printf("OD (Online Detection)\n"); break;
        case 0x4: printf("FCS (Failure Control by System Supervisor)\n"); break;
        default: printf("This is not expected.\n");
    }
 
    
    if(!read_slice)
    {
        printf("No Comparator Slice mismatch\n");
    }
    else
    {
        for(int i=0; i<23; i++)
        {
            if(read_slice&0x1) printf("Mismatch in Slice %d\n", i);
            read_slice=read_slice/2;
        }
    } 
}

// Lockstep Initialization
void lockstep_init() {
    /*
    * Provide timeout acknowledgment (ERRCTRL_TIMEOUT_ACK)
    * Verify timeout counter stopped (ERRCTRL_TIMEOUT) by 
    * delaying more than timeout period
    * Max timeout period at 100MHz processor clock is 10.44 milliseconds
    */
    IOWR_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD428, 0x78A5C3E1);
    IOWR_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD428, 0x875A3C1E);
    unsigned char count1 = IORD_8DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD424);
    usleep(10000);
    unsigned char count2 = IORD_8DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD424);
    if(count1 == count2) printf("Timeout acknowledged.\n");

    /*
    * Disable timeout (ERRCTRL_TIMEOUT)
    * 1. Unlock ERRCTRL_TIMEOUT
    * 2. Verify unlocked status
    * 3. Write new timeout deadline as 0 (Disable)
    * 4. Lock ERRCTRL_TIMEOUT
    */
    IOWR_8DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD428, (0x19<<1));
    unsigned int timeout_csr = IORD_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD424);
    printf("Timeout Period = %d\n", timeout_csr&0xff);
    if(timeout_csr&0x01000000) 
    {
        printf("Unlocked Success.\n");
    } else
    {
        printf("Still Locked. Failed to unlock.\n");
    }

    IOWR_8DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD424, 0);
    IOWR_8DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD428, 0);
    timeout_csr = IORD_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD424);
    if(timeout_csr&0x01000000) 
    {
        printf("Still Unlocked. Failed to lock.\n");
    } else
    {
        printf("Locked Success.\n");
    }
    timeout_csr = IORD_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD424);
    printf("Timeout Period = %d\n", timeout_csr&0xff);
    if((timeout_csr&0xff) == 0) printf("Timeout disabled.\n");
 
    // Verify no alarm mask
    unsigned int maskA = IORD_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD44C)&0xffffff;
    unsigned int maskB = IORD_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD450)&0xffffff;
    if((maskA == 0x555555)&&(maskB == 0x555555))
    {
        printf("All alarms are unmasked.\n");
    }
    else {
        printf("Alarms are Masked!!!");
    }
    printf("********************************************\n");
}

// Lockstep Reset function
void lockstep_reset() {
    /* 
    * Reset the Niosv/g processor using PIO
    */
    printf("*******Lockstep processor Reset*******\n");

    // Assert resetreq via PIO_0
    IOWR_ALTERA_AVALON_PIO_DATA(RST_REQ_PIO_BASE, 1);
    printf("Reset request asserted to Lockstep processor\n");
 
    // Short delay
    usleep(100000);

    // Deassert resetreq via PIO_0
    IOWR_ALTERA_AVALON_PIO_DATA(RST_REQ_PIO_BASE, 0);
    printf("Reset request to Lockstep processor deasserted\n");
    // usleep(100000);
    
}

int main(){
    // Initial Reset to bring Lockstep Niosv/g processor out of reset
    lockstep_reset();
    
    // Set the Acknowlegment value (ACK) to 0x01
    IOWR_ALTERA_AVALON_PIO_DATA(RST_ACK_PIO_BASE, 0x01);
    printf("Acknowledge set to 1");
    usleep(100000);

    // Poll for ACK from NiosV/g via PIO_1
    unsigned int ack = 0;
    while ((ack = IORD_ALTERA_AVALON_PIO_DATA(RST_ACK_PIO_BASE)) != 0x02);
    usleep(100000);
    printf("Reset ACK received from Lockstep processor\n");
    
    // Lockstep Initilization Procedure
    lockstep_init();
 
    // Alarm Detection before injecting Root Fault
    alarm_detection();

    // Multiple iterations of Failsafe mechanism
    for (int i = 1; i <= 3; i++) { 
        /*
        * Configure and Start Root Fault Injection
        * 1. Select BUS_D_CNTRL as target slice (ERRCTRL_PGO0)
        * 2. Inject Comparator Self-detection
        *     with faulty frSmartComp (ERRCTRL_ROOT_INJ)
        */
        IOWR_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD460, 0x4);
        IOWR_32DIRECT(LOCKSTEP_CONFIG_BASE_ADDR, 0xD444, 0x5);   
        printf("*********Root Fault Injected*********\n");  

        // Detection after Root Fault Injection
        alarm_detection();

        // Reset Lockstep processor
        lockstep_reset();
        // Set ACK value to 0x03 for handshake with Niosv/g lockstep processor
        IOWR_ALTERA_AVALON_PIO_DATA(RST_ACK_PIO_BASE, 0x03);

        // Detection after Lockstep Processor Reset
        alarm_detection();

    }
 
    return 0;
 
}

