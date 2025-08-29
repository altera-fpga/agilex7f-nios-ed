# Nios® V/m Processor – DDR, DMA and OCM Memory Test

 Nios V/m Processor-based Memory Test design Example on Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA

## Description

This example design includes a NIOS V/m embedded processor connected to the External Memory Interface (EMIF), DMA, On Chip RAM and JTAG UART IP. 
The objective of the design is to accomplish a data transfer between the On Chip RAM and the DDR (EMIF) using a DMA (MSGDMA) IP. 
DMA facilitates the data transfer which is then read back by the processor.

![image](https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014ea-dev-devkit/niosv_m/ddr_dma_ocm_mem_test/img/block_diagram.png)


## Project Details

- **Title**: Nios® V/m Processor DDR,DMA and OCM Memory test Design
- **Source**: Github
- **Design Support**: CTH
- **Family**: Agilex 7
- **Quartus Version**: 25.1.1
- **Development Kit**: Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA
- **Device Part**: AGFB014R24B2E2V
- **Design Package**: agilex7_niosv_m_ddr_dma_ocm_mem_test.zip
- **Category**: Memory
- **URL**: https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014ea-dev-devkit/niosv_m/ddr_dma_ocm_mem_test/
- **download URL**: https://github.com/altera-fpga/agilex7f-nios-ed/releases/download/25.1.1-v1.0/agilex7_niosv_m_ddr_dma_ocm_mem_test.zip

## Documentation

- **Title**: Design Document
- **URL**: https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014ea-dev-devkit/niosv_m/ddr_dma_ocm_mem_test/docs/NiosV_m_Processor_OCM_Memory_test_Example_design_on_Agilex_7_FPGA.md


# Getting Started

Vendor: Altera

1. Directory structure
2. Using existing files (sof and elf) to run on hardware
3. Building the design from scratch

    a.	Required directory structure

    b.	Use of build_sof.py to compile the design

    c.	Steps to create the bsp and build software sources

    d.  Hardware Validation 

### 1. Directory Structure:

The directory structure is explained below:

- hw- necessary hardware files (.qpf, .qsf, .sv, .v, .ip) of the design

- sw- This folder contains software application files

- scripts- This folder consists of scripts to build the design


### 2. Using existing files to run the design on hardware

- The sof and elf files required to run the design can be found in "ready_to_test" folder 

- Refer the Hardware validation section (3.d) for the steps  


### 3. Building the design from scratch

The steps to build the project from scratch are mentioned below:

a. Required directory structure
- The top-level project folder should have directory structure as mentioned in Section 1 (Directory Structure).

b. Using build_sof.py to compile the design
- Invoke the quartus_py shell in the terminal

- Run the following command in the terminal from top level project directory:
```
quartus_py ./scripts/build_sof.py
```
- The quartus tool will compile the design and generate the output files

c. Creating the bsp, build software sources and download elf
- To create software app, run the following commands in the terminal:

- Clean the app build project before regenerating elf

```  
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/qsys_top.qsys --type=hal --script=sw/bsp-update-linker-to-ocm.tcl sw/bsp/settings.bsp
niosv-app --bsp-dir=sw/niosv_bsp --app-dir=sw/niosv_app --srcs=sw/niosv_app/main.c
niosv-shell
cmake -S ./sw/app -B sw/app/build
make -C sw/app/build
elf2hex sw/niosv_app/build/niosv_app.elf -b 0x0 -w 32 -e 0x9ffff hw/onchip_mem.hex
```

d. Hardware Validation
- Program the generated sof and then download the elf file on the board
```        
quartus_pgm --cable=1 -m jtag -o 'p;ready_to_test/top.sof'
``` 
- Reduce the JTAG clock frequency to 6MHz before programming the application .elf file on the board.
```
jtagconfig --setparam 1 JtagClock 6M
```
- Download the elf file on the board 
```    
niosv-download -g ready_to_test/app.elf -c 1
``` 
- Verify the output on the terminal by using the following command in the terminal:
``` 
juart-terminal -d 1 -c 1 -i 0 
```
