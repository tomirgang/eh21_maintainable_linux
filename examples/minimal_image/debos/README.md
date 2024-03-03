# Debos minimal QEMU image

## Prepare the image build

- Install Debos: `sudo apt install debos`

## Build the image

```bash
debos qemu-aarch64/qemu-aarch64.yaml
```

## Run the image

I wasn't able to find a way to automatically extract the kernel and initrd from the imaage during the debos build.

My way to get the kernel and initrd is loop-mounting the image and copy the files.
I automated this as `extract_kernel.sh`

When the kernel and initrd is extracted, you can run the image with:

```bash
qemu-system-aarch64 \
	-machine virt \
	-cpu cortex-a72 \
	-m 4096 \
	-nographic \
	-netdev user,id=mynet0,hostfwd=tcp::2222-:22 \
	-device virtio-net-pci,netdev=mynet0 \
	-kernel vmlinuz-6.1.0-18-arm64 \
	-append "earlycon root=/dev/vda2" \
  	-initrd initrd.img-6.1.0-18-arm64 \
  	-drive if=virtio,format=raw,file=qemu-aarch64.img
```

# QEMU image using grub-efi for arm64

## Build the image

```bash
debos qemu-aarch64-grub-efi/qemu-aarch64-grub-efi.yaml
```

## Run the image

```bash
qemu-system-aarch64 \
	-machine virt \
	-cpu cortex-a72 \
	-m 4096 \
	-nographic \
	-netdev user,id=mynet0 \
	-device virtio-net-pci,netdev=mynet0 \
	-drive file=qemu-aarch64.img,if=virtio  \
	-bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd
```

# Evaluation

- build time: 
- startup time:
- size:
- runnig services:
- installed packages: