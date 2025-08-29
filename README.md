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


# 1. agf014eb-si-devkit 
Example Designs using Nios V as the core based on Agilex™ 7 FPGA F-Series Transceiver-SoC Development Kit (P-Tile and E-Tile)

Development kit product page- https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/si-agf014.html 

The following table contains the list of the designs on Agilex™ 7 FPGA F-Series Transceiver-SoC Development Kit (P-Tile and E-Tile)

| No # | Design Name Prefix (Nios V core) | Design Name Suffix (Functions) | Description |
| - | --- | ------ | ----------- |
| 1 | Nios V/g | Nios V/g FPU Design | Nios V/g Processor-based design example with Floating Point Unit (FPU) on Agilex™ 7 FPGA F-Series Transceiver-SoC Development Kit (P-Tile and E-Tile)<br>[Design details](agf014eb-si-devkit/niosv_g/fpu_test/docs/NiosV_g_Processor_Floating_Point_Unit_Example_design_on_Agilex_7_FPGA.md) |
| 2 | Nios V/g | Nios V/g Tightly Coupled Memory (TCM) Design | This design is about how to use the TCM feature in Nios V/g Processor<br>[Design details](agf014eb-si-devkit/niosv_g/tcm_mem_test/docs/Nios_Vg_Processor_Tightly_Coupled_Memory_Test_Design_on_Agilex_7_FPGA.md)|
| 3 | Nios V/m | Nios V/m Iperf Design | This design demonstrates Iperf server application running on the development kit interacting with Iperf client on remote host<br>[Design details](agf014eb-si-devkit/niosv_m/agilex7_sisoc_iperf/docs/NiosV_m_Processor_Iperf_Design_on_Agilex_7_FPGA.md) |
| 4 | Nios V/m | Nios V/m Simple Socket Server (SSS) Design | This design demonstrates Simple Socket Server Application<br>[Design details](agf014eb-si-devkit/niosv_m/agilex7_sisoc_sss/docs/NiosV_m_Processor_SSS_Design_on_Agilex_7_FPGA.md) |

--------------------------------------------------------------------------------------------------------------------------------------------------------------------



# 2. agf014ea-dev-devkit 
Example Designs using Nios V as the core based on Agilex™ 7 FPGA F-Series Development Kit (P-Tile and E-Tile)

Development kit product page- https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agf014.html

The following table contains the list of the designs on Agilex™ 7 FPGA F-Series Development Kit (P-Tile and E-Tile)

| No # | Design Name Prefix (Nios V core) | Design Name Suffix (Functions) | Description |
| - | --- | ------ | ----------- |
| 1 | Nios V/g | Nios V/g TinyML LiteRT | This design demonstrates the TinyML application using LiteRT for microcontrollers software with Nios® V/g processor<br>[Design details](agf014ea-dev-devkit/niosv_g/tinyml_liteRT/docs/Nios_Vg_Processor_TinyML_Design_on_Agilex_7_FPGA.md) |
| 2 | Nios V/g | Nios V/g Custom Instruction (CI) Basic Operations Design| This design demonstrates basic arithmetic and logic operations using the custom instruction feature of the Nios® V/g processor<br>[Design details](agf014ea-dev-devkit/niosv_g/ci_basic_operations/docs/Nios_Vg_Processor_CI_Basic_Operations_Design_on_Agilex_7_FPGA.md) |
| 3 | Nios V/g | Nios V/g Custom Instruction (CI) Cyclic Redundency Check (CRC) Design | This design demonstrates the Cyclic Redundancy Check (CRC) algorithm using the custom instruction feature of the Nios® V/g processor<br>[Design details](agf014ea-dev-devkit/niosv_g/ci_crc/docs/Nios_Vg_Processor_CI_CRC_Design_on_Agilex_7_FPGA.md) |
| 4 | Nios V/g | Nios V/g ECC | This design demonstrates the ECC Lite feature of the Nios® V/g core by injecting an error on the General-Purpose Register (GPR) via simulation<br>[Design details](agf014ea-dev-devkit/niosv_g/ecc_lite/docs/NiosV_g_Processor_ECC_Lite_test_Example_design_on_Agilex_7_FPGA.md)
| 5 | Nios V/g | Nios V/g Helloworld Design | Nios V/g Processor-based Helloworld example design<br>[Design details](agf014ea-dev-devkit/niosv_g/hello_world/docs/Nios_Vg_Processor_Hello_World_Design_on_Agilex_7_FPGA.md)
| 6 | Nios V/c | Nios V/c PIO OCM test Design | Nios V/c Processor-based Helloworld and OCM memory test example design<br>[Design details](agf014ea-dev-devkit/niosv_c/pio_ocm/docs/Nios_Vc_Processor_PIO_OCM_Design_on_Agilex_7_FPGA.md)
| 7 | Nios V/m | Nios V/m DDR DMA OCM Memory Test | This design demonstrates Nios V/m Processor-based Memory Test design Example<br>[Design details](agf014ea-dev-devkit/niosv_m/ddr_dma_ocm_mem_test/docs/Nios_Vm_Processor_DDR_DMA_Design_on_Agilex_7_FPGA.md) |
| 8 | Nios V/m | Nios V/m DMA OCM Memory Test Design| This design demonstrates Nios V/m Processor-based Direct Memory Access (DMA) and On-Chip Memory (OCM) Test <br>[Design details](agf014ea-dev-devkit/niosv_m/dma_ocm_mem_test/docs/Nios_Vm_Processor_DMA_OCM_Design_on_Agilex_7_FPGA.md) |
| 9 | Nios V/m | Nios V/m EMIF Design | This design demonstrates Nios V/m Processor-based External Memory Interface (EMIF) data mover example design <br>[Design details](agf014ea-dev-devkit/niosv_m/emif_mem_test/docs/Nios_Vm_Processor_EMIF_Design_on_Agilex_7_FPGA.md) |
| 10 | Nios V/m | Nios V/m ISR Test |This design demonstrates Nios V/m Processor-based Timer Interrupt design Example<br>[Design details](agf014ea-dev-devkit/niosv_m/isr_test/docs/NiosV_m_Processor_Timer_Interval_Interrupt_Test_Example_design_on_Agilex_7_FPGA.md)
| 11 | Nios V/m | Nios V/m Helloworld Design | Nios V/m Processor-based Helloworld example design<br>[Design details](agf014ea-dev-devkit/niosv_g/hello_world/docs/Nios_Vg_Processor_Hello_World_Design_on_Agilex_7_FPGA.md)
| 12 | Nios V/m | Nios V/m OCM Memory Test Design | Nios V/m Processor-based On-Chip Memory (OCM) Test design<br>[Design details](agf014ea-dev-devkit/niosv_m/ocm_mem_test/docs/NiosV_m_Processor_OCM_Memory_test_Example_design_on_Agilex_7_FPGA.md)
| 13 | Nios V/m | Nios V/m PIO Design | This design demonstrates the transaction between the Nios® V processor and the PIO core<br>[Design details](agf014ea-dev-devkit/niosv_m/pio_test/docs/NiosV_m_Processor_PIO_test_Example_design_on_Agilex_7_FPGA.md)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------


# 3. agf014ea-dev-devkit 
Example Designs using Nios V as the core based on  Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)

Development kit product page - https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agf027-and-agf023.html 

The following table contains the list of the designs on Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)

| No # | Design Name Prefix (Nios V core) | Design Name Suffix (Functions) | Description |
| - | --- | ------ | ----------- |
| 1 | Nios V/m | Nios V/m Transceiver Loopback design | This design demonstrates the serial loopback via QSFPDD on Agilex™ 7 FPGA F-Series Development Kit (2xF-Tile)  <br>[Design details](agf027f1es-dev-devkit/niosv_m/xcver_ser_lp/docs/Nios_Vm_Processor_PAM4_8x53Gbps_with_QSFPDD_Serial_loopback_design.md) |


Refer to the documents in the following link for More information on the Nios V Processor core - [https://www.intel.com/content/www/us/en/support/programmable/support-resources/support-centers/nios-v-support.html ](https://www.intel.com/content/www/us/en/support/programmable/support-resources/support-centers/nios-v-support.html#introtext_1506028531_1693475107)
