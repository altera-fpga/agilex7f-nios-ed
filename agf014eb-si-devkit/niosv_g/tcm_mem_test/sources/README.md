# Agilex 7 FPGA - Tightly Coupled Memory (TCM) Design Example on Nios® V/g Processor 

Nios® V/g Processor-based TCM example design on the Agilex® 7 FPGA.

## Description

This example design is about how to use tightly coupled memory in Nios® V/g processor. The example application measures the memory access speed of different memories connected to the processor, such as TCM, on-chip memory and external memory interface (EMIF). In addition to that, the application showcases the speedup between cached and un-cached memories.

![image](https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014eb-si-devkit/niosv_g/tcm_mem_test/img/agilex7_tcm.png)

## Project Details

- **Title**: Agilex 7 FPGA - Tightly Coupled Memory (TCM) Design Example on Nios® V/g Processor 
- **Source**: Github
- **Design Support**: CTH
- **Family**: Agilex 7
- **Quartus Version**: 25.1.1
- **Development Kit**: Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA
- **Device Part**: AGFB014R24B2E2V
- **Design Package**: agilex7_tcm.zip
- **Category**: Memory
- **URL**: https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014eb-si-devkit/niosv_g/tcm_mem_test
- **download URL**: https://github.com/altera-fpga/agilex7f-nios-ed/releases/download/25.1.1-v1.0/agilex7_niosv_g_tcm_mem_test.zip

## Documentation

- **Title**: Design Document
- **URL**: https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014eb-si-devkit/niosv_g/tcm_mem_test/docs/NiosV_g_Processor_Tightly_Coupled_Memory_Example_design_on_Agilex_7_FPGA.md

# Getting Started

Vendor: Altera

Devkit Product Page: www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/f-series/dev-agf014.html

1. Directory structure
2. Using existing files (sof and elf) to run on hardware
3. Building the design from scratch
    
    a.	Required directory structure
    
    b.	Use of build_sof.py to compile the design
    
    c.	Steps to create the bsp and build software sources
    
    d.  Hardware Validation 

### 1. Directory Structure:

The directory structure of this top-level project folder is explained below:

- hw - necessary hardware files (.qpf, .qsf, .sv, .v, .ip) of the design

- sw - This folder contains software application files

- scripts - This folder consists of scripts to build the design

### 2. Using existing files to run the design on hardware

- The sof and elf files required to run the design can be found in "ready_to_test" folder

- Refer the Hardware validation section (3.d) for the steps

### 3. Building the design from scratch

The steps to build the project from scratch are mentioned below:

#### a. Required directory structure

- The top-level project folder should have directory structure as mentioned in Section 1 (Directory Structure).

#### b. Using build_sof.py to compile the design

- Invoke the quartus_py shell in the terminal

- Run the following command in the terminal from top level project directory:
```
quartus_py ./scripts/build_sof.py
```
- The quartus tool will compile the design and generate the output files

#### c. Creating the bsp, build software sources and download elf
- To create software app with HAL OS, run the following commands in the terminal

- Clean the app build project before regenerating elf

```
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/sys.qsys --type=hal sw/bsp/settings.bsp
niosv-app --bsp-dir=sw/bsp --app-dir=sw/app --srcs=sw/app/
niosv-shell
cmake -S ./sw/app -G "Unix Makefiles" -B sw/app/build
make -C sw/app/build
niosv-download -g sw/app/build/app.elf -c 1
```

#### d. Hardware Validation

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
juart-terminal -c 1 -i 0
```