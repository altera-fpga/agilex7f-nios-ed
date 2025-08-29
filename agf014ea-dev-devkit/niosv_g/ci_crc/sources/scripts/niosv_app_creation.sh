niosv-bsp -c --quartus-project=hw/ci_crc.qpf --qsys=hw/sys.qsys --type=hal sw/bsp_crc/settings.bsp
niosv-app --bsp-dir=sw/bsp_crc --app-dir=sw/app_crc --srcs=sw/app_crc/crc_main.c --srcs=sw/app_crc/ci_crc.c --srcs=sw/app_crc/crc.c
cmake -S ./sw/app_crc -B sw/app_crc/build
make -C sw/app_crc/build
elf2hex sw/app_crc/build/app_crc.elf -b 0x0 -w 32 -e 0x9ffff hw/onchip_mem.hex -r4