# Kiwi-ng Rapsberry Pi example

Building an image for the Raspberry Pi 4 using kiwi-ng and the kiwi-boxed-plugin.

The kiwi-boxed-plugin is needed for cross-building an image for aarch64 on x86_64.

Original image: https://github.com/OSInside/kiwi-descriptions/tree/main/ubuntu/aarch64/ubuntu-jammy-rpi

Modifications:
- Reduce root filesystem to only contain essential packages.
- Human readable password
- Use Suse apt repo url instead of OBS url

## Prepare the image build

- Prepare venv: `python3 -m venv venv`
- Activate venv: `source ./venv/bin/activate`
- Install kiwi-ng: `pip install kiwi`
- Install boxed plugin: `pip install kiwi-boxed-plugin`
- Add bin folder of venv to path: `export PATH=${PWD}\venv\bin:$PATH`

## Build the image

```bash
kiwi-ng --debug --target-arch=aarch64 system boxbuild \
  --box ubuntu --aarch64 --cpu=cortex-a57 --machine=virt --no-accel -- \
  --description=ubuntu-jammy-rpi --target-dir=build
```

## Flash the image

Use dd:

```bash
xzcat kiwi-test-image-rpi.aarch64.img.xz | dd of=/dev/SDCARDNAMEGOESHERE
```

Or use a UI tool like https://etcher.balena.io/.
