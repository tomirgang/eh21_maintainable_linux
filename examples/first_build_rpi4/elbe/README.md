# Elbe Rapsberry Pi example

Building an image for the Raspberry Pi 4 using elbe.

Image based in tutorial https://bootlin.com/blog/elbe-automated-building-of-ubuntu-images-for-a-raspberry-pi-3b/

> [!IMPORTANT]
> The default disk compression using a tar.gz archive caused a broken image on my machine.

## Prepare the image build

Setup the initvm:

- Install elbe: `sudo apt install elbe`
- Create initvm: `elbe initvm create --directory /data/elbe/demovm` 

## Build the image

```bash
elbe initvm submit --skip-build-bin --skip-build-sources rpi-image/aarch64_rpi4.xml
```

## Flash the image

Use dd as root:

```bash
dd if=sdcard.img of=/dev/SDCARDNAMEGOESHERE
```

Or use a UI tool like https://etcher.balena.io/.
