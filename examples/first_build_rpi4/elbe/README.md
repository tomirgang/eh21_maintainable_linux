# Elbe Rapsberry Pi example

Building an image for the Raspberry Pi 4 using elbe.

Image based in tutorial https://bootlin.com/blog/elbe-automated-building-of-ubuntu-images-for-a-raspberry-pi-3b/


## Prepare the image build

- Install elbe: `sudo apt install elbe`
- Create initvm: `elbe initvm create --directory /data/elbe/demovm` 

## Build the image

```bash
elbe initvm submit rpi-image/aarch64_rpi4.xml
```

## Flash the image

Use dd as root:

```bash
gzip -dc sdcard.img.tar.gz | dd of=/dev/SDCARDNAMEGOESHERE
```

Or use a UI tool like https://etcher.balena.io/.
