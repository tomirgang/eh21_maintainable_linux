# BeagleBone Black image

## Prepare the image build

Setup the initvm:

- Install elbe: `sudo apt install elbe`
- Create initvm: `elbe initvm create --directory /data/elbe/demovm` 

## Build the image

```bash
elbe initvm submit --build-sdk image/armhf-ti-beaglebone-black.xml
```

## Flash the image

Use dd as root:

```bash
dd if=sdcard.img of=/dev/SDCARDNAMEGOESHERE
```

Or use a UI tool like https://etcher.balena.io/.
