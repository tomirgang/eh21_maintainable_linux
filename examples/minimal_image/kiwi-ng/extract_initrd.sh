#!/bin/bash

set -e

mkdir -p root

sudo mount -o loop ${PWD}/build/qemu_aarch64_debian.aarch64-1.0.0 ${PWD}/root

rm -f initrd.img-*

cp ${PWD}/root/boot/initrd.img-* build/

sudo umount ${PWD}/root
