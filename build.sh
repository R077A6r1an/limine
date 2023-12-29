#!/bin/bash -e

# Expecting as input the following variables:
# $1 : Absolute path to the limine.cfg file
# $2 : Absolute path to your kernel path

# First configure all things
./bootstrap
./configure --enable-bios-cd --enable-uefi-cd --enable-uefi-x86-64 --enable-bios

# Now build the bootloader from source
make

cd bin
mkdir -p iso/EFI/BOOT
cp BOOTX64.EFI iso/EFI/BOOT
cp $1 iso
cp $2 iso
cp limine-uefi-cd.bin iso
cp limine-bios-cd.bin iso
cp limine-bios.sys iso
xorriso -as mkisofs -b limine-bios-cd.bin \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        --efi-boot limine-uefi-cd.bin \
        -efi-boot-part --efi-boot-image --protective-msdos-label \
        iso -o image.iso
