#find . -type f -name "*.gz" -exec gzip -d -f '{}' '+'
#niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/qsys_top.qsys --type=hal --script=sw/bsp-update-linker-niosv-ocm-emif.tcl sw/niosv_bsp/settings.bsp
#niosv-bsp -u --script=sw/bsp-update-linker-niosv-ocm-emif.tcl sw/niosv_bsp/settings.bsp
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/qsys_top.qsys --type=hal sw/bsp/settings.bsp
niosv-app --bsp-dir=sw/bsp --app-dir=sw/app_hal --srcs=sw/app_hal/hello.c
cmake -S ./sw/app_hal -B sw/app_hal/build
make -C sw/app_hal/build
#elf2hex sw/app/build/app.elf -b 0x0 -w 32 -e 0xfffff hw/qsys_top_tb/qsys_top_tb/sim/mentor/onchip_mem.hex
elf2hex sw/app_hal/build/app_hal.elf -b 0x0 -w 32 -e 0x3FFFF hw/onchip_mem.hex -r4
#niosv-download -g sw/app/build/app.elf -c 1
