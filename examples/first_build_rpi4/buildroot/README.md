# Buildroot Rapsberry Pi example

Building an image for the Raspberry Pi 4 using Buildroot.


## Prepare the build

- Clone Buildroot: `git clone git@gitlab.com:buildroot.org/buildroot.git`
- Create rpi4 config: `make raspberrypi4_64_defconfig` 

## Build the image

```bash
make
```

## Flash the image

Use dd as root:

```bash
dd if=output/images/sdcard.img of=/dev/SDCARDNAMEGOESHERE
```

Or use a UI tool like https://etcher.balena.io/.

