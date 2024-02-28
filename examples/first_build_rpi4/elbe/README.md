# Elbe Rapsberry Pi example

Building an image for the Raspberry Pi 4 using elbe.

Image based in tutorial https://bootlin.com/blog/elbe-automated-building-of-ubuntu-images-for-a-raspberry-pi-3b/


## Prepare the image build

- Install elbe: `sudo apt install elbe`
- Create initvm: `elbe initvm create --directory /data/elbe/demovm` 
- Ensure initvm is running: `elbe initvm start`
- 

## Build the image

```bash
debos rpi64/debimage-rpi64.yaml
```

## Flash the image

Use dd as root:

```bash
gzip -dc debian-rpi64.img.gz | dd of=/dev/SDCARDNAMEGOESHERE
```

Or use a UI tool like https://etcher.balena.io/.
