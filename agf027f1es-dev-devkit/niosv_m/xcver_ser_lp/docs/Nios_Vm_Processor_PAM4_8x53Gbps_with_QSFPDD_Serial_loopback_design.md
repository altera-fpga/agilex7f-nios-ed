## Introduction

### Agilex 7 FPGA - Nios V/m Transceiver Loopback design

F-Tile Transceiver loopback design on Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)

### Prerequisites
 
 - Agilex™ 7 FPGA F-Series (2 × F-Tiles) Development Kit, ordering code DK-DEV-AGF027F1ES. Refer to the board documentation for more information about the development kit.
 - Mini and Micro USB Cable. Included with the development kit.

### Release Contents  

#### Binaries
 - Prebuilt binaries are located [here](https://github.com/altera-fpga/agilex7e-nios-ed/blob/rel/25.3.0/agf027f1es-dev-devkit/niosv_m/xcver_ser_lp/ready_to_test).
 - The sof and elf files required to run the design can be found in "ready_to_test" folder 
 - Program the sof and download the elf file on board

### Agilex 7 FPGA - Nios V/m Transceiver Loopback design Architecture

![Block Diagram](https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.3.0/agf027f1es-dev-devkit/niosv_m/xcver_ser_lp/img/niosv_xcver.png)

#### Nios® V/m Processor
- Microcontroller- Balanced (For interrupt driven baremetal and RTOS code)
- Nios® V/m processor is highly customizable and can be tailored to meet specific application requirements, providing flexibility and scalability in embedded system designs.
 
#### IP Cores
 The following IPs are used in this Platform Designer component of the design:
- Nios® V/m soft processor core

- On Chip RAM-II

- JTAG UART

- Sys ID

- F-Tile PMA/FEC Direct PHY Intel FPGA IP

- F-Tile Reference and System PLL Clocks Intel FPGA 

### Address Map Details

### Hardware Setup

Refer to [Agilex™ 7 FPGA F-Series (2 × F-Tiles) Development Kit User Guide](https://www.intel.com/content/www/us/en/docs/programmable/739942/current/overview.html) to setup the hardware connection.

#### Nios V Address Map
 |Address Offset	|Size (Bytes)	|Peripheral	| Description|
  |-|-|-|-|
  |0x0|4M|On-Chip RAM|To store application|
  |0x2000_0000|512M|Phy_reg_set|On board PHY Communication|
  |0x0041_3048|8|JTAG UART|Communication between a host PC and the Nios V processor system|
  |0x0041_0340|8|System ID|Hardware configuration system ID (0x00000009)|

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

### Environment Setup

#### Tools Download and Installation
1. Quartus Prime Pro

 - Download the Quartus® Prime Pro Edition software version 25.3.0 from the FPGA Software Download Center webpage of the Intel website. Follow the on-screen instructions to complete the installation process. Choose an installation directory that is relative to the Quartus® Prime Pro Edition software installation directory.
 - Set up the Quartus tools in the PATH, so they are accessible without full path.
```console
export QUARTUS_ROOTDIR=~/intelFPGA_pro/25.3.0/quartus/
export PATH=$QUARTUS_ROOTDIR/bin:$QUARTUS_ROOTDIR/linux64:$QUARTUS_ROOTDIR/../qsys/bin:$PATH
```

#### Compilation 

#### Hardware Compilation 

- Invoke the quartus_py shell in the terminal

- Run the following command in the terminal from top level project directory:
```
quartus_py ./scripts/build_sof.py
```
- The quartus tool will compile the design and generate the output files

#### Software Compilation 
- To create software app with HAL OS, run the following commands in the terminal:

``` 
niosv-bsp -c --quartus-project=hw/devkit_demo.qpf --qsys=hw/controller.qsys --type=hal sw/bsp/hal_default/settings.bsp
niosv-app --bsp-dir=sw/bsp/hal_default --app-dir=sw/app/Agilex_xCh --elf-name=Agilex_xCh.elf --srcs=sw/app/Agilex_xCh/input_functions.c --srcs=sw/app/Agilex_xCh/channel_functions.c --srcs=sw/app/Agilex_xCh/nphy_functions.c --srcs=sw/app/Agilex_xCh/PMA_functions_FTILE.c --srcs=sw/app/Agilex_xCh/FEC_functions_FTILE.c --srcs=sw/app/Agilex_xCh/main.c
niosv-shell
cmake -S ./sw/app/Agilex_xCh -B sw/app/Agilex_xCh
make -C sw/app/Agilex_xCh
```

### Programing 
Note: Reduce the JTAG clock frequency to 6MHz using the following command, before programming the sof file
```console
jtagconfig --setparam 1 JtagClock 6M
```

#### Program Hardware Binary SOF
- Program the generated sof and then download the elf file on the board
``` 
quartus_pgm --cable=1 -m jtag -o 'p;ready_to_test/devkit_demo.sof'
```

#### Program Software Image ELF
- Download the elf file on the board 
```
niosv-download -g ready_to_test/Agilex_xCh.elf -c 1
```

### Testing

#### Open JTAG UART Terminal
- Verify the output on the terminal by using the following command in the terminal:
```
juart-terminal -c 1 -i 0 
```