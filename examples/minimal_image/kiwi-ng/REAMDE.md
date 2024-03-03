# Kiwi-ng minimal QEMU image

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
  --description=qemu-aarch64-minimal --target-dir=build
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
	-kernel /path/to/custom/Image \
  -append "earlycon root=/dev/vda1" \
  -drive if=virtio,format=qcow2,file=disk.img \
	-bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd
```

## Results

- build time:
- startup time:
- size:
- runnig services:
- installed packages:
