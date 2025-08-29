## Introduction

### Nios® V/m Processor – DMA - OCM Memory Test Design Overview

 Nios V/m Processor-based Direct Memory Access (DMA) and On-Chip Memory (OCM) Test design Example on Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA

### Prerequisites

 -  Agilex® 7 FPGA F-Series Development Kit, ordering code DK-DEV-AGF014EA. Refer to the board documentation for more information about the development kit.
 - Mini and Micro USB Cable. Included with the development kit.
 
### Release Contents  

#### Binaries
 - Prebuilt binaries are located [here](https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014ea-dev-devkit/niosv_m/dma_ocm_mem_test/ready_to_test).
 - The sof and elf files required to run the design can be found in "ready_to_test" folder 
 - Program the sof and download the elf file on board

## Nios® V/m Processor – DMA - OCM Memory Test Design Architecture

This example design includes a NIOS V/m embedded processor connected to the DMA, On Chip RAM and JTAG UART IP. 
The objective of the design is to accomplish a data transfer between the 2 On Chip RAM using a DMA (MSGDMA) IP. 
DMA facilitates the data transfer which is then read back by the processor.

![image](https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014ea-dev-devkit/niosv_m/dma_ocm_mem_test/img/dma_ocm.png)


#### Nios® V/m Processor
- Microcontroller- Balanced (For interrupt driven baremetal and RTOS code)
- Nios® V/m processor is highly customizable and can be tailored to meet specific application requirements, providing flexibility and scalability in embedded system designs.
 
#### IP Cores
 The following IPs are used in this Platform Designer component of the design:
- Nios® V/m soft processor core

- On Chip RAM-II

- JTAG UART

- DMA

- System ID

- Clock Bridge, Reset Controller


### Hardware Setup

Refer to [Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile User Guide](https://www.intel.com/content/www/us/en/docs/programmable/683024/current/overview.html) to setup the hardware connection.

### Address Map Details

#### Nios V Address Map
 |Address Offset	|Size (Bytes)	|Peripheral	| Description|
  |-|-|-|-|
  |0x0|1M|On-Chip RAM|To store application|
  |0x0101_0048|8|JTAG UART|Communication between a host PC and the Nios V processor system|
  |0x0101_0040|8|System ID|Hardware configuration system ID (0x00000009)|


## User Flow 

 There are two ways to test the design based on use case. 

   <h5> User Flow 1: Testing with Prebuild Binaries.</h5>
   
   <h5> User Flow 2: Testing Complete Flow.</h5>

 |User Flow|Description|Required for [User flow 1](#user-flow-1-testing-with-prebuild-binaries)|Required for [User flow 2](#user-flow-2-testing-complete-flow)|
 |-|-|-|-|
 |Environment Setup|[Tools Download and Installation](#tools-download)|Yes|Yes|
 |Compilation|Hardware compilation|No|Yes|
 ||Software compilation|No|Yes|    
 |Programing|Program Hardware Binary SOF|Yes|Yes|
 ||Program Software Image ELF|Yes|Yes|
 |Testing|Open JTAG UART Terminal|Yes|Yes|

### Environment Setup

#### Tools Download and Installation
1. Quartus Prime Pro

 - Download the Quartus® Prime Pro Edition software version 25.1.1 from the FPGA Software Download Center webpage of the Intel website. Follow the on-screen instructions to complete the installation process. Choose an installation directory that is relative to the Quartus® Prime Pro Edition software installation directory.
 - Set up the Quartus tools in the PATH, so they are accessible without full path.
```console
export QUARTUS_ROOTDIR=~/intelFPGA_pro/25.1.1/quartus/
export PATH=$QUARTUS_ROOTDIR/bin:$QUARTUS_ROOTDIR/linux64:$QUARTUS_ROOTDIR/../qsys/bin:$PATH
```

### Compilation 

#### Hardware Compilation 
- Invoke the quartus_py shell in the terminal

- Run the following command in the terminal from top level project directory:
```
quartus_py ./scripts/build_sof.py
```
- The quartus tool will compile the design and generate the output files

#### Software Compilation
- To create software app, run the following commands in the terminal:

- Clean the app build project before regenerating elf

```  
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/qsys_top.qsys --type=hal sw/bsp/settings.bsp
niosv-app --bsp-dir=sw/niosv_bsp --app-dir=sw/niosv_app --srcs=sw/niosv_app/main.c
niosv-shell
cmake -S ./sw/app -B sw/app/build
make -C sw/app/build
elf2hex sw/app/build/app.elf -b 0x0 -w 32 -e 0xfffff hw/onchip_mem.hex -r4
```

### Programing 
- Program the generated sof and then download the elf file on the board
```        
quartus_pgm --cable=1 -m jtag -o 'p;ready_to_test/top.sof'
``` 
- Reduce the JTAG clock frequency to 6MHz before programming the application .elf file on the board.
```
jtagconfig --setparam 1 JtagClock 6M
```

#### Program Software Image ELF
- Download the elf file on the board 
```    
niosv-download -g ready_to_test/app.elf -c 1
``` 

### Testing

#### Open JTAG UART Terminal
- Verify the output on the terminal by using the following command in the terminal:
``` 
juart-terminal -d 1 -c 1 -i 0 
```
