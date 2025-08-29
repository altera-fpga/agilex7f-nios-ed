# Agilex 7 FPGA- Nios® V/c Processor PIO & OCM Test Design 

This design demonstrates the transaction between the Nios® V processor and the PIO core along with OCM Memory test.


## Description

The PIO core is configured for output ports only and the outputs are connected to the LED on the development kit. The application, which runs atop this design, toggles these output registers of the PIO core. The application writes and reads back the content from the IP location. Additionally, the OCM memory tests are performed.

![image](https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014ea-dev-devkit/niosv_c/pio_ocm/pio.png)

## Project Details

- **Title**: Nios® V/c Processor PIO & OCM Test Design
- **Source**: Github
- **Design Support**: SCTH
- **Family**: Agilex 7
- **Quartus Version**: 25.1.1 Pro
- **Development Kit**: Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA
- **Device Part**: AGFB014R24B2E2V
- **Design Package**: agilex7_niosv_c_pio_ocm.zip
- **Category**: PIO LED Toggle
- **URL**: https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014ea-dev-devkit/niosv_c/pio_ocm
- **download URL**: https://github.com/altera-fpga/agilex7f-nios-ed/releases/download/25.1.1-v1.0/agilex7_niosv_c_pio_led_toggle.zip

## Documentation

* **Title**: Design Document
* **URL**: https://github.com/altera-fpga/agilex5e-nios-ed/tree/rel/25.1.1/niosv_c/pio_ocm/img/block_diagram.png

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
    
4. Running simulation

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
- To create software app, run the following commands in the terminal:

- Clean the app build project before regenerating elf
```        
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/qsys_top.qsys --type=hal --script=sw/bsp-update-small-driver.tcl sw/bsp/settings.bsp
niosv-app --bsp-dir=sw/bsp --app-dir=sw/app --srcs=sw/app/main.c
cmake -S ./sw/app -B sw/app/build
make -C sw/app/build
elf2hex sw/app/build/app.elf -b 0x0 -w 32 -e 0xfffff hw/onchip_mem.hex
```

### d. Hardware Validation
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

### 4. Running simulation

Simulation is enabled for this design where the memory is initialized with the application hex. Use the following commands to run the simulation:

- Generate Testbench from Platform Designer. Generate -Generate Testbench System 
```
cp ./sw/app/build/onchip_mem.hex ./qsys_top_tb/qsys_top_tb/sim/mentor 
cd hw/qsys_top_tb/qsys_top_tb/sim/mentor/
vsim &
source msim_setup.tcl
ld_debug
run -all
```