# Nios V Example Designs Repository

This repository contains the Nios V Example designs based on different Altera FPGA development kits.

The following table contains the list of Acronyms that the user may come across in the design details

| Acronym | Expansion |
| --- | ------ |
| DMA | Direct Memory Access |
| OCM | On-Chip Memory |
| PIO | Parallel I/O |
| RTOS | Real Time Operating System |
| ECC | Error-Correcting Code |
| TCM | Tightly Coupled Memory |
| GHRD | Golden Hardware Reference Design |
| SSS | Simple Socket Server |
| CI | Custom Instrcution |
| CRC | Cyclic Redundancy Check |


There are three variants of the NiosV core:
    
    a. Nios V/m core - Microcontroller- Balanced (For interrupt driven baremetal and RTOS code)
    
    b. Nios V/g core - General-Purpose Processor- High Performance (For interrupt driven baremetal and RTOS code)

    c. Nios V/c core - Compact Microcontroller- Smallest (For non-interrupt driven baremetal code)


# 1. agf014ea-dev-devkit 
Example Designs using Nios V as the core based on Agilex™ 7 FPGA F-Series Development Kit (P-Tile and E-Tile)

Development kit product page- https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agf014.html

The following table contains the list of the designs on Agilex™ 7 FPGA F-Series Development Kit (P-Tile and E-Tile)

| No # | Design Name Prefix (Nios V core) | Design Name Suffix (Functions) | Description |
| - | --- | ------ | ----------- |
| 1 | Nios V/g | Nios V/g TinyML LiteRT | This design demonstrates the TinyML application using LiteRT for microcontrollers software with Nios® V/g processor<br>[Design details](agf014ea-dev-devkit/niosv_g/tinyml_liteRT/docs/Nios_Vg_Processor_TinyML_Design_on_Agilex_7_FPGA.md) |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------


# 2. agf014ea-dev-devkit 
Example Designs using Nios V as the core based on  Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)

Development kit product page - https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agf027-and-agf023.html 

The following table contains the list of the designs on Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)

| No # | Design Name Prefix (Nios V core) | Design Name Suffix (Functions) | Description |
| - | --- | ------ | ----------- |
| 1 | Nios V/m | Nios V/m Transceiver Loopback design | This design demonstrates the serial loopback via QSFPDD on Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)  <br>[Design details](agf027f1es-dev-devkit/niosv_m/xcver_ser_lp/docs/Nios_Vm_Processor_PAM4_8x53Gbps_with_QSFPDD_Serial_loopback_design.md) |


Refer to the documents in the following link for More information on the Nios V Processor core - [https://www.intel.com/content/www/us/en/support/programmable/support-resources/support-centers/nios-v-support.html ](https://www.intel.com/content/www/us/en/support/programmable/support-resources/support-centers/nios-v-support.html#introtext_1506028531_1693475107)
