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

- build time: 19,90s user 9,48s system 6% cpu 6:59,87 total
- startup time:
  - [   13.812610] systemd[1]: Started systemd-journald.service - Journal Service.
  - [   13.893644] systemd[1]: Started systemd-journald.service - Journal Service.
  - [   14.168924] systemd[1]: Started systemd-journald.service - Journal Service.
- size: 785M
- running services: 9  (`systemctl --type=service --state=running`)
- installed packages: 116 (`dpkg -l | wc -l`)
