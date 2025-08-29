# Nios® V/g Processor-based ECC Lite example design

 Agilex 7 FPGA - ECC Lite Design Example on Nios® V/g Processor

## Description 

 This design demonstrates the ECC Lite feature of the Nios® V/g core by injecting an error on the General-Purpose Register (GPR) via simulation.
 
 The ECC status and ECC source is observed for both correctable and uncorrectable errors on the General-Purpose Registers (GPR).
 
 The Error is injected on the OCM (M20k) GPR through the ECC parity flip feature. The parity value in the GPR is flipped using the force command in the test bench file (sys_tb.v). 
 
 The ECC Status and ECC Source signals are probed and observed using Questa Simulation
 
 ![image](https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014ea-dev-devkit/niosv_g/agilex7_ecc_lite/img/agilex7_ecc_lite.png)

## Project Details

- **Title**: Nios® V/g Processor ECC Lite test Design
- **Source**: Github
- **Design Support**: SCT
- **Family**: Agilex 7
- **Quartus Version**: 25.1.1
- **Development Kit**: Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA
- **Device Part**: AGFB014R24B2E2V
- **Design Package**: agilex7_ecc_lite.zip
- **Category**: ECC
- **URL**: https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014ea-dev-devkit/niosv_g/agilex7_ecc_lite
- **download URL**: https://github.com/altera-fpga/agilex7f-nios-ed/releases/download/25.1.1-v1.0/agilex7_niosv_g_ecc_lite.zip

## Documentation

- **Title**: Design Document
- **URL**: https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014ea-dev-devkit/niosv_g/ecc_lite_test/docs/NiosV_g_Processor_ECC_Lite_test_Example_design_on_Agilex_7_FPGA.md


### Prerequisites

 - Agilex™ 7 FPGA F-Series Development Kit (P-Tile and E-Tile), ordering code DK-DEV-AGF014EA. Refer to the board documentation for more information about the development kit.
 - Mini and Micro USB Cable. Included with the development kit.
 - Host PC with 64 GB of RAM. Less will be fine for only exercising the binaries, and not rebuilding the GHRD.

### Release Contents  

#### Binaries
 - Prebuilt binaries are located [here](https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014ea-dev-devkit/niosv_g/agilex7_ecc_lite/ready_to_test).
 - The sof and elf files required to simulate the design can be found in "ready_to_test" folder 


#### Nios® V/g Processor 
- Balanced (For interrupt driven baremetal and RTOS code)
- Nios® V/g processor is highly customizable and can be tailored to meet specific application requirements, providing flexibility and scalability in embedded system designs.

#### IP Cores
 The following IPs are used in this Platform Designer component of the design:
- Nios® V/g soft processor core

- On Chip RAM-II

- JTAG UART

- System ID

- Clock Bridge, Reset Controller


### Hardware Setup

  Refer to [Agilex™ 7 FPGA F-Series Development Kit (P-Tile and E-Tile) Development Kit User Guide](https://www.intel.com/content/www/us/en/docs/programmable/683024.html) to setup the hardware connection.

### Address Map Details

#### Nios V Address Map
 |Address Offset	|Size (Bytes)	|Peripheral	| Description|
  |-|-|-|-|
  |0x0000_0000|655360|On-Chip RAM|To store application|
  |0x0011_0040|8|JTAG UART|Communication between a host PC and the Nios V processor system|
  |0x0021_2040|8|System ID|Hardware configuration system ID (0x00000009)|
  ||||

## User Flow 

 There are two ways to test the design based on use case. 

   <h5> User Flow 1: Testing with Prebuild Binaries.</h5>
   
   <h5> User Flow 2: Testing Complete Flow.</h5>

 |User Flow|Description|Required for [User flow 1](#user-flow-1-testing-with-prebuild-binaries)|Required for [User flow 2](#user-flow-2-testing-complete-flow)|
 |-|-|-|-|
 |Environment Setup|[Tools Download and Installation](#tools-download)|Yes|Yes|
 |Compilation|Hardware compilation|No|Yes|
 ||Software compilation|No|Yes|    
 ||Run simulation|Yes|Yes|
 ||||
 
### Environment Setup

#### Tools Download and Installation
1. Quartus Prime Pro

 - Download the Quartus® Prime Pro Edition software version 25.1 from the FPGA Software Download Center webpage of the Intel website. Follow the on-screen instructions to complete the installation process. Choose an installation directory that is relative to the Quartus® Prime Pro Edition software installation directory.
 - Set up the Quartus tools in the PATH, so they are accessible without full path.
```console
	export QUARTUS_ROOTDIR=~/intelFPGA_pro/25.1/quartus/
	export PATH=$QUARTUS_ROOTDIR/bin:$QUARTUS_ROOTDIR/linux64:$QUARTUS_ROOTDIR/../qsys/bin:$PATH
```


### Getting Started

Vendor: Altera

1. Directory structure
2. Building the design from scratch
3. Running simulation

 
### 1. Directory Structure:
 
The directory structure of this top-level project folder is explained below:

- hw - necessary hardware files (.qpf, .qsf, .sv, .v, .ip) of the design

- sw - This folder contains software application files

- scripts - This folder consists of scripts to build the design

 
### 2. Building the design from scratch
 
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
 
c. Creating the bsp, build software sources and hex
- To create software app, run the following commands in the terminal

- Clean the app build project before regenerating hex
```
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/sys.qsys --type=hal sw/bsp/settings.bsp
niosv-app --bsp-dir=sw/bsp --app-dir=sw/app --srcs=sw/app/hello.c
cmake -S ./sw/app -B sw/app/build
make -C sw/app/build
elf2hex sw/app/build/app.elf -b 0x0 -w 32 -e 0xfffff ./hw/onchip_mem.hex
elf2hex sw/app/build/app.elf -b 0x0 -w 32 -e 0xfffff hw/sys_tb/sys_tb/sim/mentor/onchip_mem.hex
```

### 3. Running simulation

Simulation is enabled for this design where the memory is initialized with the application hex. Use the following commands to run the simulation:

- Generate Testbench from Platform Designer. Generate -> Generate Testbench System

```
cp -rf ./load_sim.tcl ./hw/sys_tb/sys_tb/sim/mentor
cp -rf ./wave.do ./hw/sys_tb/sys_tb/sim/mentor
cp -rf ./hw/sys_tb.v ./hw/sys_tb/sys_tb/sim
cd hw/sys_tb/sys_tb/sim/mentor/
vsim &
source msim_setup.tcl
ld_debug
run -all
```