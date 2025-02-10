1. Directory structure
2. Using existing files (sof and elf) to run on hardware
3. Building the design from scratch
    
    a. Required directory structure

    b. Use of build_sof.py to compile the design
    
    c. Steps to create the bsp and build software sources

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
```
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/sys.qsys --type=hal sw/bsp_crc/settings.bsp
niosv-app --bsp-dir=sw/bsp_crc --app-dir=sw/app --srcs=sw/app/
niosv-shell
cmake -S ./sw/app -G "Unix Makefiles" -B sw/app/build
make -C sw/app/build
niosv-download -g sw/app/build/app.elf -c 1
```

### 4. Running simulation

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