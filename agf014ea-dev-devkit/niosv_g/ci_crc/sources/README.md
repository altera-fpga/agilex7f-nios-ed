1. Directory structure
2. Using existing files (sof and elf) to run on hardware
3. Building the design from scratch
    
    a. Required directory structure
    
    b. Use of build_sof.py to compile the design
    
    c. Steps to create the bsp and build software sources
    
    d. Hardware Validation

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
- To create software app with HAL OS, run the following commands in the terminal

- Clean the app build project before regenerating elf
```    
niosv-bsp -c --quartus-project=hw/ci_crc.qpf --qsys=hw/sys.qsys --type=hal sw/bsp_crc/settings.bsp
niosv-app --bsp-dir=sw/bsp_crc --app-dir=sw/app_crc --srcs=sw/app_crc/srcs/
niosv-shell
cmake -S ./sw/app_crc -G "Unix Makefiles" -B sw/app_crc/build
make -C sw/app_crc/build
```

d. Hardware Validation
- Program the generated sof and then download the elf file on the board
```
quartus_pgm --cable=1 -m jtag -o 'p;ready_to_test/ci_crc.sof'  
```
- Reduce the JTAG clock frequency to 6MHz before programming the application .elf file on the board.
``` 
jtagconfig --setparam 1 JtagClock 6M
```
- Download the elf file on the board
```
niosv-download -g ready_to_test/app_crc.elf -c 1
```
- Verify the output on the terminal by using the following command in the terminal:
```
juart-terminal -c 1 -i 0
```

### 4. Running simulation

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