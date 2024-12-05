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

> hw- necessary hardware files (.qpf, .qsf, .sv, .v, .ip) of the design

> sw- This folder contains software application files

> scripts- This folder consists of scripts to build the design


### 2. Using existing files to run the design on hardware

> The sof and elf files required to run the design can be found in "ready_to_test" folder 

> Refer the Hardware validation section (3.d) for the steps  


### 3. Building the design from scratch

The steps to build the project from scratch are mentioned below:

a. Required directory structure

    - The top-level project folder should have directory structure as mentioned in Section 1 (Directory Structure).

b. Using build_sof.py to compile the design

    - Invoke the quartus_py shell in the terminal

    - Run the following command in the terminal from top level project directory:

        > quartus_py build_sof.py

    - The quartus tool will compile the design and generate the output files

c. IP Address configuration
    
    - Please refer the below web-link for configuring the IP Address
        https://www.intel.com/content/www/us/en/docs/programmable/726952/22-4-22-4-0/optional-configuration.html

d. Creating the bsp, build software sources and download elf
    - To create software app with HAL OS, run the following commands in the terminal:
    
        > niosv-bsp -c sw/bsp/settings.bsp -qpf=hw/top.qpf -qsys=hw/sys.qsys --type=ucosii --cmd="enable_sw_package uc_tcp_ip" --cmd="set_setting altera_avalon_jtag_uart_driver.enable_small_driver {1}" --cmd="set_setting hal.enable_instruction_related_exceptions_api {1}" --cmd="set_setting hal.log_flags {0}" --cmd="set_setting hal.log_port {sys_jtag_uart}" --cmd="set_setting hal.make.cflags_defined_symbols {-DTSE_MY_SYSTEM}" --cmd="set_setting hal.make.cflags_user_flags {-ffunction-sections -fdata-sections}" --cmd="set_setting hal.make.cflags_warnings {-Wall -Wextra -Wformat -Wformat-security}" --cmd="set_setting hal.make.link_flags {-Wl,--gc-sections}" --cmd="set_setting ucosii.miscellaneous.os_max_events {80}" --cmd="set_setting ucosii.os_tmr_en {1}" --cmd="set_setting hal.make.cflags_optimization {-O2 -fno-tree-vectorize}"
    
        > niosv-app --bsp-dir=sw/bsp --app-dir=sw/app --incs=sw/app,sw/app/uC-IPerf --srcs=sw/app/app_iperf.c,sw/app/main.c,sw/app/uC-IPerf/OS/uCOS-II/iperf_os.c,sw/app/uC-IPerf/Reporter/Terminal/iperf_rep.c,sw/app/uC-IPerf/Source/iperf-c.c,sw/app/uC-IPerf/Source/iperf-s.c,sw/app/uC-IPerf/Source/iperf.c,sw/app/uc_tcp_ip_init.c
    
        > niosv-shell
    
        > cmake -S sw/app -B sw/app/build -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=Release
    
        > make -j4 -C sw/app/build

e. Hardware Validation

    - Program the generated sof and then download the elf file on the board
       
        > quartus_pgm --cable=1 -m jtag -o 'p;ready_to_test/<top_level_entity_name>.sof'
    
    - Download the elf file on the board
       
        > niosv-download -g ready_to_test/<>.elf -c 1
   
    - Verify the output on the terminal by using the following command in the terminal:
       
        > juart-terminal -c 1 -i 0
