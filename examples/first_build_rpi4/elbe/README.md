# Elbe Rapsberry Pi example

Building an image for the Raspberry Pi 4 using elbe.

Image based in tutorial https://bootlin.com/blog/elbe-automated-building-of-ubuntu-images-for-a-raspberry-pi-3b/


## Prepare the image build

Setup the initvm:

- Install elbe: `sudo apt install elbe`
- Create initvm: `elbe initvm create --directory /data/elbe/demovm` 

The following steps are a workaround since elbe has no option to configure components, and the raspi-firmware package is part of the component non-free-firmware.

Prepare a new project:

- `elbe control create_project --directory /data/elbe/demovm > project`
- `export PRJ=$(cat project)`

Get Raspberry Pi firmware package:

- `wget http://ftp.de.debian.org/debian/pool/non-free-firmware/r/raspi-firmware/raspi-firmware_1.20230405+ds-2_all.deb`
- `elbe prjrepo upload_pkg --directory /data/elbe/demovm $PRJ raspi-firmware_1.20230405+ds-2_all.deb`

Embed the overlay in the XML:

- `elbe chg_archive rpi-image/aarch64_rpi4.xml rpi-image/overlays/networkd`

Build the image:

- `elbe initvm submit --directory /data/elbe/demovm $PRJ rpi-image/aarch64_rpi4.xml`

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
