#!/bin/bash

qemu-system-aarch64 \
	-machine virt \
	-cpu cortex-a72 \
	-m 4096 \
	-nographic \
	-netdev user,id=mynet0,hostfwd=tcp::2222-:22 \
	-device virtio-net-pci,netdev=mynet0 \
	-kernel kernel \
	-append "earlycon root=/dev/vda" \
  	-initrd initrd.img \
  	-drive if=virtio,format=raw,file=image
