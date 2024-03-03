#!/bin/bash

qemu-system-aarch64 \
	-machine virt \
	-cpu cortex-a72 \
	-m 4096 \
	-nographic \
	-netdev user,id=mynet0,hostfwd=tcp::2222-:22 \
	-device virtio-net-pci,netdev=mynet0 \
	-kernel build/qemu_aarch64_minimal.aarch64-1.0.0-0/qemu_aarch64_minimal.aarch64-1.0.0-5.15.0-25-generic.kernel \
  	-append "earlycon root=/dev/sda rw" \
  	-drive file=build/qemu_aarch64_minimal.aarch64-1.0.0-0/qemu_aarch64_minimal.aarch64-1.0.0
