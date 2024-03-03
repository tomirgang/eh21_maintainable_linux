# Elbe Rapsberry Pi example

Building an image for the Raspberry Pi 4 using elbe.

Image based in tutorial https://bootlin.com/blog/elbe-automated-building-of-ubuntu-images-for-a-raspberry-pi-3b/

TODO: integrated image has broken disks, extracted disk partitions and tbz is OK!

## Prepare the image build

Setup the initvm:

- Install elbe: `sudo apt install elbe`
- Create initvm: `elbe initvm create --directory /data/elbe/demovm` 

## Build the image

```bash
elbe initvm submit --skip-build-bin --skip-build-sources rpi-image/aarch64_rpi4.xml
```

> [!IMPORTANT]
> The overlays are encoded and embedded in the XML. To update the network config, 
> delete the old archive tag and create a new one with:
> `elbe chg_archive rpi-image/aarch64_rpi4.xml rpi-image/overlays/networkd`

## Flash the image

Use dd as root:

```bash
gzip -dc sdcard.img.tar.gz | dd of=/dev/SDCARDNAMEGOESHERE
```

Or use a UI tool like https://etcher.balena.io/.
