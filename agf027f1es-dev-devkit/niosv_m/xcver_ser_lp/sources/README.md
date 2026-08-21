# Agilex 7 FPGA - Nios V/m Transceiver Loopback design

F-Tile Transceiver loopback design on Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)

## Description

This design demonstrates the serial loopback via QSFPDD on Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)

![image](https://github.com/altera-fpga/agilex7-ed-niosv/blob/rel/26.1.1/agf027f1es-dev-devkit/niosv_m/xcver_ser_lp/img/niosv_xcver.png)

## Project Details

- **Title**: Nios® V/m Processor Transceiver Loopback design
- **Source**: Github
- **Design Support**: SCTH
- **Family**: Agilex 7
- **Quartus Version**: 26.1.1
- **Development Kit**: Agilex 7 FPGA F-Series Development Kit 2xF-Tile DK-DEV-AGF027F1ES
- **Device Part**: AGFD023R24C2E1VC
- **Design Package**: agilex7_xcver_loopback.zip
- **Category**: Transceiver
- **URL**: https://github.com/altera-fpga/agilex7-ed-niosv/blob/rel/26.1.1/agf027f1es-dev-devkit/niosv_m/xcver_ser_lp
- **download URL**: https://github.com/altera-fpga/agilex7-ed-niosv/releases/download/26.1.1/agilex7_xcver_loopback.zip

## Documentation

* **Title**: Design Document
* **URL**: https://github.com/altera-fpga/agilex7-ed-niosv/blob/rel/26.1.1/agf027f1es-dev-devkit/niosv_m/xcver_ser_lp/docs

# Getting Started

Vendor: Altera
Devkit Product Page: https://www.altera.com/products/devkit/po-3004/agilex-7-fpga-f-series-development-kit-2x-f-tile-agf023

1. Directory structure
2. Using existing files (sof and elf) to run on hardware
3. Building the design from scratch
    
    a.	Required directory structure
    
    b.	Use of build_sof.py to compile the design
    
    c.	Steps to create the bsp and build software sources
    
    d.  Hardware Validation 

### 1. Directory Structure:

The directory structure is explained below:

- hw - necessary hardware files (.qpf, .qsf, .sv, .v, .ip) of the design

- sw - This folder contains software application files

- scripts - This folder consists of scripts to build the design

### 2. Using existing files to run the design on hardware

- The sof and elf files required to run the design can be found in "ready_to_test" folder
- Program the sof and download the elf file on board

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

- To create software app with HAL OS, run the following commands in the terminal:

``` 
niosv-bsp -c --quartus-project=hw/devkit_demo.qpf --qsys=hw/controller.qsys --type=hal sw/bsp/hal_default/settings.bsp
niosv-app --bsp-dir=sw/bsp/hal_default --app-dir=sw/app/Agilex_xCh --elf-name=Agilex_xCh.elf --srcs=sw/app/Agilex_xCh/input_functions.c --srcs=sw/app/Agilex_xCh/channel_functions.c --srcs=sw/app/Agilex_xCh/nphy_functions.c --srcs=sw/app/Agilex_xCh/PMA_functions_FTILE.c --srcs=sw/app/Agilex_xCh/FEC_functions_FTILE.c --srcs=sw/app/Agilex_xCh/main.c
niosv-shell
cmake -S ./sw/app/Agilex_xCh -B sw/app/Agilex_xCh
make -C sw/app/Agilex_xCh
```

d. Hardware Validation
- Program the generated sof and then download the elf file on the board
``` 
quartus_pgm --cable=1 -m jtag -o 'p;ready_to_test/devkit_demo.sof'
```
- Reduce the JTAG clock frequency to 6MHz before programming the application .elf file on the board.
```
jtagconfig --setparam 1 JtagClock 6M
```
- Download the elf file on the board 
```
niosv-download -g ready_to_test/Agilex_xCh.elf -c 1
```
- Verify the output on the terminal by using the following command in the terminal:
```
juart-terminal -c 1 -i 0 
```