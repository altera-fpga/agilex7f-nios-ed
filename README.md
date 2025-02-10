# Nios V Example Designs Repository

This repository contains the Nios V Example designs based on different Altera Agilex™ FPGA Development Kits.

The following table contains the list of Acronyms that the user may come across in the design details

| Acronym | Expansion |
| --- | ------ |
| DMA | Direct Memory Access |
| OCM | On-Chip Memory |
| PIO | Parallel I/O |
| RTOS | Real Time Operating System |
| ECC | Error-Correcting Code |
| TCM | Tightly Coupled Memory |
| SSS | Simple Socket Server |
| CI | Custom Instrcution |
| CRC | Cyclic Redundancy Check |

There are three variants of the NiosV core:
    
    a. Nios V/m core - Microcontroller- Balanced (For interrupt driven baremetal and RTOS code)
    
    b. Nios V/g core - General-Purpose Processor- High Performance (For interrupt driven baremetal and RTOS code)

    c. Nios V/c core - Compact Microcontroller- Smallest (For non-interrupt driven baremetal code)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Development Kit OPN | Development Kit Name | Development Kit product page URL |
| --- | ------ | ----------- |
| agf014ea-dev-devkit | Agilex™ 7 FPGA F-Series Development Kit (P-Tile and E-Tile) | https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agf014.html |

The following table contains the list of the designs on Agilex™ 7 FPGA F-Series Development Kit (P-Tile and E-Tile)

| No # | Design Name Prefix (Nios V core) | Design Name Suffix (Functions) | Description |
| - | --- | ------ | ----------- |
| 1 | Nios V/g | Nios V/g Custom Instruction (CI) Basic Operations Design| This design demonstrates basic arithmetic and logic operations using the custom instruction feature of the Nios® V/g processor<br>[Design details](agf014ea-dev-devkit/niosv_g/ci_basic_operations/docs/Nios_Vg_Processor_Custom_Instruction_Design_on_Agilex_7_FPGA.pdf) |
| 2 | Nios V/g | Nios V/g Custom Instruction (CI) Cyclic Redundency Check (CRC) Design | This design demonstrates the Cyclic Redundancy Check (CRC) algorithm using the custom instruction feature of the Nios® V/g processor<br>[Design details](agf014ea-dev-devkit/niosv_g/ci_crc/docs/Nios_Vg_Processor_Custom_Instruction_CRC_Design_on_Agilex_7_FPGA.pdf) |
| 3 | Nios V/g | Nios V/g ECC | This design demonstrates the ECC Lite feature of the Nios® V/g core by injecting an error on the General-Purpose Register (GPR) via simulation<br>[Design details](agf014ea-dev-devkit/niosv_g/ecc_lite/docs/Nios_Vg_Processor_ECC_Lite_Design_on_Agilex_7_FPGA.pdf)
| 4 | Nios V/c | Nios V/c PIO OCM test Design | Nios V/c Processor-based Helloworld and OCM memory test example design<br>[Design details](agf014ea-dev-devkit/niosv_c/pio_ocm/docs/Nios_Vc_Processor_PIO_OCM_Design_on_Agilex_7_FPGA.pdf)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Development Kit OPN | Development Kit Name | Development Kit product page URL |
| --- | ------ | ----------- |
| agf014eb-si-devkit | Agilex™ 7 FPGA F-Series Transceiver-SoC Development Kit (P-Tile and E-Tile) | https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/si-agf014.html |

The following table contains the list of the designs on Agilex™ 7 FPGA F-Series Transceiver-SoC Development Kit (P-Tile and E-Tile)

| No # | Design Name Prefix (Nios V core) | Design Name Suffix (Functions) | Description |
| - | --- | ------ | ----------- |
| 1 | Nios V/m | Nios V/m Iperf Design | This design demonstrates Iperf server application running on the development kit interacting with Iperf client on remote host<br>[Design details](agf014eb-si-devkit/niosv_m/agilex7_sisoc_iperf/docs/Agilex™_7_FPGA_Iperf_design_on_Nios®V_m_Processor.pdf) |
| 2 | Nios V/m | Nios V/m Simple Socket Server (SSS) Design | This design demonstrates Simple Socket Server Application<br>[Design details](agf014eb-si-devkit/niosv_m/agilex7_sisoc_sss/docs/Agilex™_7_FPGA_Simple_Socket_Server_design_on_Nios®V_m_Processor.pdf) |
| 3 | Nios V/g | Nios V/g Tightly Coupled Memory (TCM) Design | This design is about how to use the TCM feature in Nios V/g Processor<br>[Design details](agf014eb-si-devkit/niosv_g/tcm_mem_test/docs/Nios_Vg_Processor_Tightly_Coupled_Memory_Test_Design_on_Agilex_7_FPGA.pdf)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Development Kit OPN | Development Kit Name | Development Kit product page URL |
| --- | ------ | ----------- |
| agf027f1es-dev-devkit | Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile) | https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agf027-and-agf023.html |

The following table contains the list of the designs on Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)

| No # | Design Name Prefix (Nios V core) | Design Name Suffix (Functions) | Description |
| - | --- | ------ | ----------- |
| 1 | Nios V/m | Nios V/m Transceiver Loopback design | This design demonstrates the serial loopback via QSFPDD on Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)  <br>[Design details](agf027f1es-dev-devkit/niosv_m/xcver_ser_lp/docs/Nios_Vm_Processor_PAM4_8x53Gbps_with_QSFPDD_Serial_loopback_design.pdf) |


Refer to the documents in the following link for More information on the Nios V Processor core - [https://www.intel.com/content/www/us/en/support/programmable/support-resources/support-centers/nios-v-support.html ](https://www.intel.com/content/www/us/en/support/programmable/support-resources/support-centers/nios-v-support.html#introtext_1506028531_1693475107)
