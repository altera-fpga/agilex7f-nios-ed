find . -type f -name "*.gz" -exec gzip -d -f '{}' '+'
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/qsys_top.qsys --type=hal --script=sw/bsp-update-linker-to-ocm.tcl sw/niosv_bsp/settings.bsp
#niosv-bsp -u --script=sw/bsp-update-linker-niosv-ocm-emif.tcl sw/niosv_bsp/settings.bsp
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/qsys_top.qsys --type=hal sw/niosv_bsp/settings.bsp
niosv-app --bsp-dir=sw/niosv_bsp --app-dir=sw/niosv_app --srcs=sw/niosv_app/main.c
cmake -S ./sw/niosv_app -B sw/niosv_app/build
make -C sw/niosv_app/build
#elf2hex sw/app/build/app.elf -b 0x0 -w 32 -e 0xfffff hw/qsys_top_tb/qsys_top_tb/sim/mentor/onchip_mem.hex
elf2hex sw/niosv_app/build/niosv_app.elf -b 0x0 -w 32 -e 0xfffff hw/onchip_mem.hex
#niosv-download -g sw/app/build/app.elf -c 1
