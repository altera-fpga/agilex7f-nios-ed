## Introduction

### Agilex 7 FPGA - Hello World Example Design Example on Nios® V/g Processor Overview

Nios® V/g Processor-based Hello World example design on the Agilex® 7 FPGA.


### Prerequisites

 - Agilex® 7 FPGA F-Series Development Kit, ordering code DK-DEV-AGF014EA. Refer to the board documentation for more information about the development kit.
 - Mini and Micro USB Cable. Included with the development kit.
 
### Release Contents  

#### Binaries
 - Prebuilt binaries are located [here](https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014ea-dev-devkit/niosv_g/hello_world/ready_to_test).
 - The sof and elf files required to run the design can be found in "ready_to_test" folder 
 - Program the sof and download the elf file on board

### Hello World Example Design Example on Nios® V/g Processor Design Architecture

Nios® V/g Processor-based Helloworld example design on the Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA. 

![image](https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014ea-dev-devkit/niosv_g/hello_world/img/hello_world.png)

#### Nios® V/g Processor
- General-Purpose Processor- High Performance (For interrupt driven baremetal and RTOS code)
- Nios® V/g processor is highly customizable and can be tailored to meet specific application requirements, providing flexibility and scalability in embedded system designs.
 
#### IP Cores
 The following IPs are used in this Platform Designer component of the design:
- Nios® V/g soft processor core

- On Chip RAM-II

- JTAG UART

- System ID

- Clock Bridge, Reset Controller


### Hardware Setup

  Refer to [Agilex® 7 FPGA F-Series Development Kit P-Tile and E-Tile User Guide](https://www.intel.com/content/www/us/en/docs/programmable/683024/current/overview.html) to setup the hardware connection.


### Address Map Details

#### Nios V Address Map
 |Address Offset	|Size (Bytes)	|Peripheral	| Description|
  |-|-|-|-|
  |0x0|650k|On-Chip RAM|To store application|
  |0x0009_0078|8|JTAG UART|Communication between a host PC and the Nios V processor system|
  |0x0021_2040|8|System ID|Hardware configuration system ID (0x00000009)|


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
 ||Run simulation|Yes|Yes|

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

### Programing
Note: Reduce the JTAG clock frequency to 6MHz using the following command, before programming the sof file
```console
jtagconfig --setparam 1 JtagClock 6M
```

#### Program Hardware Binary SOF
- Program the generated sof and then download the elf file on the board
```  
quartus_pgm --cable=1 -m jtag -o 'p;ready_to_test/top.sof'
```

#### Program Software Image ELF
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

### Testing

#### Open JTAG UART Terminal
- Verify the output on the terminal by using the following command in the terminal:
``` 
juart-terminal -d 1 -c 1 -i 0 
```

### Running simulation

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