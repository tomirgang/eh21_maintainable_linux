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

```bash
qemu-system-aarch64 \
	-machine virt \
	-cpu cortex-a72 \
	-m 4096 \
	-nographic \
	-netdev user,id=mynet0,hostfwd=tcp::2222-:22 \
	-device virtio-net-pci,netdev=mynet0 \
	-kernel vmlinuz \
	-append "earlycon root=/dev/vda2" \
  	-initrd initrd.img \
  	-drive if=virtio,format=raw,file=sdcard.img
```

## Results

- build time:
- startup time:
- size:
- runnig services:
- installed packages:
