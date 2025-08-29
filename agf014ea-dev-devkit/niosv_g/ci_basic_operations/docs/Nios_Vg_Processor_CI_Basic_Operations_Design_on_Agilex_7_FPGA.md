## Introduction

### Agilex 7 FPGA - Custom Instruction Basic Operations Design Example on Nios® V/g Processor Design Overview

Nios® V/g Processor-based custom instruction example design on the Agilex® 7 FPGA.

### Prerequisites

 -  Agilex® 7 FPGA F-Series Development Kit, ordering code DK-DEV-AGF014EA. Refer to the board documentation for more information about the development kit.
 - Mini and Micro USB Cable. Included with the development kit.
 
### Release Contents  

#### Binaries
 - Prebuilt binaries are located [here](https://github.com/altera-fpga/agilex7f-nios-ed/tree/rel/25.1.1/agf014ea-dev-devkit/niosv_g/ci_basic_operations/ready_to_test).
 - The sof and elf files required to run the design can be found in "ready_to_test" folder 
 - Program the sof and download the elf file on board

### Custom Instruction Basic Operations Design Example on Nios® V/g Processor Design Architecture

A Processing Engine (PE) that performs basic arithmetic and logical computations is connected to the Nios® V/g processor using the custom instruction interface. 

The current version of the Nios® V/g processor custom instruction interface supports operations up-to 32-Bit. 

![image](https://github.com/altera-fpga/agilex7f-nios-ed/blob/rel/25.1.1/agf014ea-dev-devkit/niosv_g/ci_basic_operations/img/niosv_ci_example.png)

#### Nios® V/g Processor
- General-Purpose Processor- High Performance (For interrupt driven baremetal and RTOS code)
- Nios® V/g processor is highly customizable and can be tailored to meet specific application requirements, providing flexibility and scalability in embedded system designs.
 
#### IP Cores
 The following IPs are used in this Platform Designer component of the design:
- Nios® V/g soft processor core

- On Chip RAM-II

- Processing Engine 1

- Processing Engine 2

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
  |0x0011_0040|8|JTAG UART|Communication between a host PC and the Nios V processor system|
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

- To create software app with HAL OS, run the following commands in the terminal

- Clean the app build project before regenerating elf
```  
niosv-bsp -c --quartus-project=hw/niosv_custom_instruction.qpf --qsys=hw/sys.qsys --type=hal sw/bsp/settings.bsp
niosv-app --bsp-dir=sw/bsp --app-dir=sw/app --srcs=sw/app/custom_instr_app.c
niosv-shell
cmake -S ./sw/app -G "Unix Makefiles" -B sw/app/build
make -C sw/app/build
``` 

### Programing
Note: Reduce the JTAG clock frequency to 6MHz using the following command, before programming the sof file
```console
jtagconfig --setparam 1 JtagClock 6M
```

#### Program Hardware Binary SOF
- Program the generated sof and then download the elf file on the board
```
quartus_pgm --cable=1 -m jtag -o 'p;ready_to_test/niosv_custom_instruction.sof'  
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
juart-terminal -c 1 -i 0
```

### Running simulation

Simulation is enabled for this design where the memory is initialized with the application hex. Use the following commands to run the simulation:
    
- Generate Testbench from Platform Designer. Generate -> Generate Testbench System

```
cp ./hw/onchip_mem.hex ./sys_tb/sys_tb/sim/mentor 
cd hw/sys_tb/sys_tb/sim/mentor/
vsim &
source msim_setup.tcl
ld_debug
run -all
```