1. Directory structure
2. Operations performed by Processing Engine (PE)
3. Using existing files (sof and elf) to run on hardware
4. Building the design from scratch
    
    a. Required directory structure
  
    b. Use of build_sof.py to compile the design
    
    c. Steps to create the bsp and build software sources
    
    d. Hardware Validation 

5. Running simulation

### 1. Directory Structure:

The directory structure of this top-level project folder is explained below:

- hw - necessary hardware files (.qpf, .qsf, .sv, .v, .ip) of the design

- sw - This folder contains software application files

- scripts - This folder consists of scripts to build the design

### 2. Operations performed by Processing Engine (PE)
 
A Processing Engine (PE) is connected to the Niosv/g processor using the custom instruction interface which performs the following 32-Bit arithmetic and logical operations:
 
- 1's complement
- 2's complement
- Multiplication
- Bit reversal (Reversing the order of Bits)
- Byte reversal (Reversing the order of Bytes)
- Word reversal (Reversing the order of words)
- Merge lower words (Combine/Merge the lower words of two inputs)
- Merge higher words (Combine/Merge the higher words of two inputs)
 
### 3. Using existing files to run the design on hardware
 
- The sof and elf files required to run the design can be found in "ready_to_test" folder 

- Refer the Hardware validation section (3.d) for the steps
 
### 4. Building the design from scratch
 
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

- To create software app with HAL OS, run the following commands in the terminal

- Clean the app build project before regenerating elf
```  
niosv-bsp -c --quartus-project=hw/niosv_custom_instruction.qpf --qsys=hw/sys.qsys --type=hal sw/bsp/settings.bsp
niosv-app --bsp-dir=sw/bsp --app-dir=sw/app --srcs=sw/app/custom_instr_app.c
niosv-shell
cmake -S ./sw/app -G "Unix Makefiles" -B sw/app/build
make -C sw/app/build
``` 

d. Hardware Validation

- Program the generated sof and then download the elf file on the board
```
quartus_pgm --cable=1 -m jtag -o 'p;ready_to_test/niosv_custom_instruction.sof'  
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

### 5. Running simulation

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