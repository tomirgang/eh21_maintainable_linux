# Elbe SDK

Use the SDK:

- Enalbe SDK env: `source environment-setup-elbe-arm-linux-gnueabihf-beaglebone-black-1.0`
- Go to app dir: `cd ../app`
- Make build folder: `mkdir build && cd build`
- Prepare makefile: `cmake ..`
- Build the app: `make`

## Check the file:

```bash
➜  build git:(main) ✗ file MyJsonApp
MyJsonApp: ELF 32-bit LSB pie executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, BuildID[sha1]=ad78ea88e551cd9a3239a8998c7cdfb1832307d6, for GNU/Linux 3.2.0, with debug_info, not stripped
```

## Use the file on the BBB:

TODO: write
