1. Directory structure
2. Using existing files (sof and elf) to run on hardware
3. Building the design from scratch
    
    a.	Required directory structure
    
    b.	Use of build_sof.py to compile the design
    
    c.	Steps to create the bsp and build software sources
    
    d.  Hardware Validation 

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

#### a. Required directory structure

- The top-level project folder should have directory structure as mentioned in Section 1 (Directory Structure).

#### b. Using build_sof.py to compile the design

- Invoke the quartus_py shell in the terminal

- Run the following command in the terminal from top level project directory:
```
quartus_py ./scripts/build_sof.py
```
- The quartus tool will compile the design and generate the output files

#### c. Creating the bsp, build software sources and download elf
- To create software app with HAL OS, run the following commands in the terminal

- Clean the app build project before regenerating elf

```
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/sys.qsys --type=hal sw/bsp/settings.bsp
niosv-app --bsp-dir=sw/bsp --app-dir=sw/app --srcs=sw/app/
niosv-shell
cmake -S ./sw/app -G "Unix Makefiles" -B sw/app/build
make -C sw/app/build
elf2hex sw/app/build/app.elf -b 0x3FFF -w 32 -e 0x7FFF sw/app/build/itcm.hex -r4
```

#### d. Hardware Validation

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
juart-terminal -c 1 -i 0
```