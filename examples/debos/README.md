# Debos Rapsberry Pi example

Building an image for the Raspberry Pi 4 using Debos.

Original image: https://github.com/go-debos/debos-recipes/tree/main/rpi64

Modifications:
- Update firmware version for Raspberry Pi 4

TODO: Image doesn't work with new firmware. New firmware complains about missing partition table.

## Prepare the image build

- Install Debos: `sudo apt install debos`

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
