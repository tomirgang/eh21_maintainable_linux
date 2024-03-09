#!/bin/bash

qemu-system-aarch64 \
	-machine virt \
	-cpu cortex-a72 \
	-m 4096 \
	-nographic \
	-netdev user,id=mynet0,hostfwd=tcp::5555-:22 \
	-device virtio-net-pci,netdev=mynet0 \
	-kernel vmlinuz-6.1.0-18-arm64 \
	-append "earlycon root=/dev/vda1" \
  	-initrd initrd.img-6.1.0-18-arm64 \
  	-drive if=virtio,format=raw,file=qemu-aarch64.img