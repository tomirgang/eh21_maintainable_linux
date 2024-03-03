# Elbe minimal QEMU image

Building a minimal QEMU image using elbe.

## Prepare the image build

Setup the initvm:

- Install elbe: `sudo apt install elbe`
- Create initvm: `elbe initvm create --directory /data/elbe/demovm` 

## Build the image

```bash
elbe initvm submit --skip-build-bin --skip-build-sources qemu-aarch64-minimal/arm64-qemu-virt.xml
```

## Run the image

Extract the disk image `build/qemu_aarch64_minimal.aarch64-1.0.0-0.tar.xz`, then run QEMU:

```bash
qemu-system-aarch64 \
	-machine virt \
	-cpu cortex-a72 \
	-m 4096 \
	-nographic \
	-netdev user,id=mynet0,hostfwd=tcp::2222-:22 \
	-device virtio-net-pci,netdev=mynet0 \
	-kernel build/qemu_aarch64_minimal.aarch64-1.0.0-0/qemu_aarch64_minimal.aarch64-1.0.0-5.15.0-25-generic.kernel \
  	-append "earlycon root=/dev/vda" \
  	-drive if=virtio,format=raw,file=build/qemu_aarch64_minimal.aarch64-1.0.0-0/qemu_aarch64_minimal.aarch64-1.0.0
```

## Results

- build time: 6625,77s user 218,60s system 258% cpu 44:03,58 total
- startup time:
- size:
- runnig services:
- installed packages:
