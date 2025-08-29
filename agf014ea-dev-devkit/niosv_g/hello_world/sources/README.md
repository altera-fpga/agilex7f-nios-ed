# Agilex 7 FPGA - Hello World Example Design Example on Nios® V/g Processor 

Nios® V/g Processor-based Hello World example design on the Agilex® 7 FPGA.

## Description

Nios® V/g Processor-based Helloworld example design on the Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA. 

![image](https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014ea-dev-devkit/niosv_g/hello_world/img/hello_world.png)

## Project Details

* **Title**: Agilex 7 FPGA - Hello World Example Design Example on Nios® V/g Processor
* **Source**: Github
* **Design Support**: SCTH
* **Family**: Agilex 7
* **Quartus Version**: 25.1.1
* **Development Kit**: Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA
* **Device Part**: AGFB014R24B2E2V
* **Design Package**: agilex7_niosv_g_hello_world.zip
* **Category**: Hello World
* **URL**: https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014ea-dev-devkit/niosv_g/hello_world
* **downloadURL**:https://github.com/altera-fpga/agilex7f-nios-ed/releases/download/25.1.1-v1.0/agilex7_niosv_g_hello_world.zip

## Documentation

* **Title**: Design Document
* **URL**: https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014ea-dev-devkit/niosv_g/hello_world/docs/Nios_Vg_Processor_Hello_World_Design_on_Agilex_7_FPGA.md

# Getting Started

Vendor: Altera

Devkit Product Page: www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/f-series/dev-agf014.html

1. Directory structure
2. Using existing files (sof and elf) to run on hardware
3. Building the design from scratch
    
    a. Required directory structure

    b. Use of build_sof.py to compile the design
    
    c. Steps to create the bsp and build software sources

    d.  Hardware Validation 
4. Running simulation
 
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
- To create software app, run the following commands in the terminal
- Clean the app build project before regenerating elf

- Building HAL application
```console
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/sys.qsys --type=hal sw/bsp_hal/settings.bsp
niosv-app --bsp-dir=sw/bsp_hal --app-dir=sw/app_hal --srcs=sw/app_hal/hello.c
cmake -S ./sw/app_hal -B sw/app_hal/build
make -C sw/app_hal/build
elf2hex sw/app_hal/build/app_hal.elf -b 0x0 -w 32 -e 0x3FFFF hw/onchip_mem.hex -r4
```

- Building uCOS-II application
```console
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/sys.qsys --type=ucosii sw/bsp_ucosii/settings.bsp
niosv-app --bsp-dir=sw/bsp_ucosii --app-dir=sw/app_ucosii --srcs=sw/app_ucosii/hello_ucosii.c
cmake -S ./sw/app_ucosii -B sw/app_ucosii/build
make -C sw/app_ucosii/build
```

- Building FreeRTOS application 
```console
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/sys.qsys --type=freertos sw/bsp_freertos/settings.bsp
niosv-app --bsp-dir=sw/bsp_freertos --app-dir=sw/app_freertos --srcs=sw/app_freertos/hello_freertos.c
cmake -S ./sw/app_freertos -B sw/app_freertos/build
make -C sw/app_freertos/build
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
HAL Application
```
niosv-download -g sw/app_hal/build/app_hal.elf -c 1
```
uCOS-II Application
```
niosv-download -g sw/app_ucosii/build/app_ucosii.elf -c 1
```
FreeRTOS Application
```
niosv-download -g sw/app_freertos/build/app_freertos.elf -c 1
```

- Verify the output on the terminal by using the following command in the terminal:
``` 
juart-terminal -d 1 -c 1 -i 0 
```

### 4. Running simulation

Simulation is enabled for this design where the memory is initialized with the application hex. Use the following commands to run the simulation:

- Generate Testbench from Platform Designer. Generate -> Generate Testbench System 
```	
cp hw/onchip_mem.hex hw/sys_tb/sys_tb/sim/mentor/onchip_mem.hex
./hw/sys_tb/sys_tb/sim/mentor
vsim &
source msim_setup.tcl
ld_debug
run -all
```