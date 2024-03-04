# Kiwi-ng minimal QEMU image

TODO: Fix QEMU command. Kernel isn't able to find root fs.

## Prepare the image build

- Prepare venv: `python3 -m venv venv`
- Activate venv: `source ./venv/bin/activate`
- Install kiwi-ng: `pip install kiwi`
- Install boxed plugin: `pip install kiwi-boxed-plugin`
- Add bin folder of venv to path: `export PATH=${PWD}/venv/bin:$PATH`

## Build the image

```bash
time kiwi-ng --debug --target-arch=aarch64 --config=kiwi.yml \
  system boxbuild \
  --box ubuntu --aarch64 --cpu=cortex-a57 --machine=virt --no-accel -- \
  --description=qemu-aarch64-debian --target-dir=build
```

## Run the image

Extract the disk image `build/qemu_aarch64_minimal.aarch64-1.0.0-0.tar.xz`,

then extract the initrd from the image `extract_initrd.sh`,

then run QEMU:

```bash
qemu-system-aarch64 \
	-machine virt \
	-cpu cortex-a72 \
	-m 4096 \
	-nographic \
	-netdev user,id=mynet0,hostfwd=tcp::2222-:22 \
	-device virtio-net-pci,netdev=mynet0 \
	-kernel build/qemu_aarch64_minimal.aarch64-1.0.0-0/qemu_aarch64_minimal.aarch64-1.0.0-5.15.0-25-generic.kernel \
  	-append "earlycon root=/dev/sda" \
  	-drive if=virtio,format=raw,file=build/qemu_aarch64_minimal.aarch64-1.0.0-0/qemu_aarch64_minimal.aarch64-1.0.0
```

# Results

- build time:
- startup time:
- size:
- runnig services:
- installed packages:
