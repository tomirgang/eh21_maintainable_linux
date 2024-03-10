# Buildroot qemu arm64

## Prepare the build

- Clone Buildroot: `git clone git@gitlab.com:buildroot.org/buildroot.git`
- Copy config from here to buildroot/.config 

## Build the image

```bash
make -j ``nproc
```

## Run the image

```bash
./output/images/start-qemu.sh
```

## Results

- build time: 6090.46s user 635.75s system 475% cpu 23:35.24 tota
- startup time: [ 3.69573] systemd[1]: Started systemd-journald.service - Journal Service.
- size: 120M roots, 12 M kernel
- running services: 45 (ps -e | wc -l)
