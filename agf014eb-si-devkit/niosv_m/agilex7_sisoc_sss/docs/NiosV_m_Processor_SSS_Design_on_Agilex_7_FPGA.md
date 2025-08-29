# Nios® V/m Simple Socket Server (SSS) Design

 Simple Socket Server design on Agilex™ 7 FPGA F-Series Transceiver-SoC Development Kit (P-Tile and E-Tile)
 
## Description

 The telnet client offers a convenient way of issuing commands over a TCP/IP socket to the Ethernet-connected μC/TCP-IP running on the development board with a simple TCP/IP socket server example. 
 The socket server example receives commands sent over a TCP/IP connection and turns LEDs on and off according to the commands. 
 The example consists of a socket server task that listens for commands on a TCP/IP port and dispatches those commands to a set of LED management tasks.  
 
 ![image](https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014eb-si-devkit/niosv_m/agilex7_sisoc_sss/img/agilex7_sss.png)
 
## Project Details

- **Title**: Nios® V/m SSS Design
- **Source**: Github
- **Design Support**: CTH
- **Family**: Agilex 7
- **Quartus Version**: 25.1.1
- **Development Kit**: Agilex™ 7 FPGA F-Series Transceiver-SoC Development Kit (P-Tile and E-Tile)
- **Device Part**: AGFB014R24B2E2V
- **Design Package**: agilex7_sisoc_sss.zip
- **Category**: Web Server
- **URL**: https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014eb-si-devkit/niosv_m/agilex7_sisoc_sss
- **download URL**: https://github.com/altera-fpga/agilex7f-nios-ed/releases/download/25.1.1-v1.0/agilex7_sisoc_sss.zip

## Documentation

- **Title**: Design Document
- **URL**:https://github.com/altera-fpga/agilex5e-nios-ed/tree/rel/25.1.1/agf014eb-si-devkit/niosv_m/agilex7_sisoc_sss/docs/NiosV_m_Processor_SSS_Design_on_Agilex_7_FPGA.md

### Prerequisites

 - Agilex™ 7 FPGA F-Series Transceiver-SoC Development Kit (P-Tile and E-Tile), ordering code DK-SI-AGF014EB. Refer to the board documentation for more information about the development kit.
 - Mini and Micro USB Cable. Included with the development kit.
 - Host PC with 64 GB of RAM. Less will be fine for only exercising the binaries, and not rebuilding the GHRD.

### Release Contents  

#### Binaries
 - Prebuilt binaries are located [here](https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014eb-si-devkit/niosv_m/agilex7_sisoc_sss/ready_to_test).
 - The sof and elf files required to simulate the design can be found in "ready_to_test" folder 

#### Nios® V/m Processor
- Microcontroller- Balanced (For interrupt driven baremetal and RTOS code)
- Nios® V/m processor is highly customizable and can be tailored to meet specific application requirements, providing flexibility and scalability in embedded system designs.
 
#### IP Cores
 The following IPs are used in this Platform Designer component of the design:
- Nios® V/m soft processor core

- Triple Speed Ethernet

- On Chip RAM-II

- MSGDMA

- JTAG UART

- System ID

- Clock Bridge, Reset Controller


### Hardware Setup

  Refer to [Agilex™ 7 FPGA F-Series Transceiver-SoC Development Kit (P-Tile and E-Tile) Development Kit User Guide](https://www.intel.com/content/www/us/en/docs/programmable/683752/current/overview.html) to setup the hardware connection.

### Address Map Details

#### Nios V Address Map
 |Address Offset	|Size (Bytes)	|Peripheral	| Description|
  |-|-|-|-|
  |0x0000_0000|2000000|On-Chip RAM|To store application|
  |0x0021_2D48|8|JTAG UART|Communication between a host PC and the Nios V processor system|
  |0x0021_24D0|8|System ID|Hardware configuration system ID (0x00000009)|
  |0x0021_2000|1024|TSE|Triple Speec Ethernet with MAC to communicate with PHY|
  ||||

### User Flow 

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
 ||Run simulation|No|No|
 
### Environment Setup

#### Tools Download and Installation
1. Quartus Prime Pro

 - Download the Quartus® Prime Pro Edition software version 25.1 from the FPGA Software Download Center webpage of the Intel website. Follow the on-screen instructions to complete the installation process. Choose an installation directory that is relative to the Quartus® Prime Pro Edition software installation directory.
 - Set up the Quartus tools in the PATH, so they are accessible without full path.
```console
	export QUARTUS_ROOTDIR=~/intelFPGA_pro/25.1.1/quartus/
	export PATH=$QUARTUS_ROOTDIR/bin:$QUARTUS_ROOTDIR/linux64:$QUARTUS_ROOTDIR/../qsys/bin:$PATH
```

### Getting Started

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

c. IP Address configuration
    
- Please refer the below web-link for configuring the IP Address

https://www.intel.com/content/www/us/en/docs/programmable/726952/22-4-22-4-0/optional-configuration.html

d. Creating the bsp, build software sources and download elf
- To create software app with HAL OS, run the following commands in the terminal:

```
niosv-bsp -c sw/bsp/settings.bsp -qpf=hw/top.qpf -qsys=hw/qsys_top.qsys --type=ucosii --cmd="enable_sw_package uc_tcp_ip" --cmd="set_setting altera_avalon_jtag_uart_driver.enable_small_driver {1}" --cmd="set_setting hal.enable_instruction_related_exceptions_api {1}" --cmd="set_setting hal.log_flags {0}" --cmd="set_setting hal.log_port {sys_jtag_uart}" --cmd="set_setting hal.make.cflags_defined_symbols {-DTSE_MY_SYSTEM}" --cmd="set_setting hal.make.cflags_user_flags {-ffunction-sections -fdata-sections}" --cmd="set_setting hal.make.cflags_warnings {-Wall -Wextra -Wformat -Wformat-security}" --cmd="set_setting hal.make.link_flags {-Wl,--gc-sections}" --cmd="set_setting ucosii.miscellaneous.os_max_events {80}" --cmd="set_setting ucosii.os_tmr_en {1}" --cmd="set_setting hal.make.cflags_optimization {-O2 -fno-tree-vectorize}"
niosv-app --bsp-dir=sw/bsp --app-dir=sw/app --incs=sw/app --srcs=sw/app/alt_error_handler.c,sw/app/led.c,sw/app/main.c,sw/app/simple_socket_server.c,sw/app/uc_tcp_ip_init.c
cmake -S sw/app -B sw/app/build -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=Release
make -j4 -C sw/app/build
```   

e. Hardware Validation
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
