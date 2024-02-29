# Yocto Rapsberry Pi example

Building an image for the Raspberry Pi 4 using yout.

Image based on yocto layer: https://git.yoctoproject.org/meta-raspberrypi
Note: There are multiple options for setting the build up, we will utilize kas,
but there are more options!

## Prepare the image build

- Install kas: `pip3 install kas`

## Build the image

```bash
kas build kas-poky-rpi.yml
```

## Flash the image

Use bmaptool

```bash
bmaptool copy build/tmp/deploy/images/raspberrypi4/core-image-minimal-raspberrypi4.rootfs.wic.bz2  /dev/SDCARDNAMEGOESHERE
```

