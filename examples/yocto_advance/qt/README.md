# Build a yocto Image with QT

## Try it out with boot2qt
Let us first try out the coffee app example from QT!

### Get sources

```
repo init -u git://code.qt.io/yocto/boot2qt-manifest -m 6.7 xml
repo sync
```

### Build image
```
export MACHINE="qemux86-64"
. ./setup-environment.sh
 bitbake b2qt-embedded-qt6-image
```

The build wll take now some time but with that we can try it out!

### Boot image

```
runqemu  qemuparams="-m 4096"
```
Note that -m passes the ammount of memory for Qemu, if it is too low the system will run out of memory.

We can see the coffee app already now!

![image info](https://github.com/tomirgang/eh21_maintainable_linux/blob/main/slides/assets/Screenshot%20from%202024-03-17%2019-27-17.png)

Let us next tailor an image where only the wanted content is included-

## TODO only build the coffee app and start it via systemd
