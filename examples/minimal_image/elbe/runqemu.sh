#!/bin/bash

RESULT=$(find -type d -name "elbe-build-*")

qemu-system-aarch64 \
	-machine virt \
	-cpu cortex-a72 \
	-m 4096 \
	-nographic \
	-netdev user,id=mynet0,hostfwd=tcp::5555-:22 \
	-device virtio-net-pci,netdev=mynet0 \
	-kernel ${RESULT}/vmlinuz \
	-append "earlycon root=/dev/vda1" \
  	-initrd ${RESULT}/initrd.img \
  	-drive if=virtio,format=raw,file=${RESULT}/sdcard.img
