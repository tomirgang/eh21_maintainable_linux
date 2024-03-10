# Yocto minimal QEMU image

## Prepare the build

- Fetch sources (if not done) `git clone git://git.yoctoproject.org/poky`
- Source env `source poky/oe-init-build-env buildir`
- Adapt conf/local.conf:
  ```
  MACHINE ?= "qemuarm64"
  BB_HASHSERVE = "auto"
  BB_SIGNATURE_HANDLER = "OEEquivHash"
  BB_HASHSERVE_UPSTREAM = "hashserv.yocto.io:8687"
  SSTATE_MIRRORS ?= "file://.* http://sstate.yoctoproject.org/all/PATH;downloadfilename=PATH"
  INIT_MANAGER = "systemd"
  ```

## Build the image

```bash
bitbake core-image-minimal
```

## Run the image

Run QEMU:

```bash
qemu-system-aarch64 \
	-device virtio-net-pci,netdev=net0,mac=52:54:00:12:34:02 \
  -netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
  -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0 \
  -drive id=disk0,file=<builddir>/tmp/deploy/images/qemuarm64/core-image-minimal-qemuarm64.rootfs.ext4,if=none,format=raw
  -device virtio-blk-pci,drive=disk0 \
  -machine virt -cpu cortex-a72 -m 4096 \
  -serial mon:stdio -serial null -nographic -device virtio-gpu-pci \
  -kernel <builddir>/tmp/deploy/images/qemuarm64/Image
  -append 'root=/dev/vda rw ip=192.168.7.2::192.168.7.1:255.255.255.0::eth0:off:8.8.8.8 net.ifnames=0 console=ttyAMA0 console=hvc0 swiotlb=0 '
```

# Results

- build time: 11.57s user 1.91s system 1% cpu 19:59.78 total
- startup time: [7.786149] systemd[1]: Started systemd-journald.service - Journal Service.
- size: Kernel: 23 M, rootfs 120 M
- runnig services: 70 (`ps -e | wc -l`)
