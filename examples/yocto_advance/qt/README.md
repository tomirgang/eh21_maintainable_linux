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
 runqemu  qemuparams="--enable-kvm -m 8G -smp 8" 
```

Note that -m passes the ammount of memory for Qemu, if it is too low the system will run out of memory.

We can see the coffee app already now!

![image info](https://github.com/tomirgang/eh21_maintainable_linux/blob/main/slides/assets/Screenshot%20from%202024-03-17%2019-27-17.png)

## Add only the coffeemachine to an image

As we most likely do not want to deploy the complete boot2qt example image for a coffeemachine,
lets build an image that:

- contains not all examples
- only needed layers
- starts the coffeemachine upon boot

Let us next tailor an image where only the wanted content is included.

### Prepare environment

It is assumed that you already fetched all layers like poky, meta-openembedded etc.

bblayer.conf could be

```
BBLAYERS ?= " \
  /sources/poky/meta \
  /sources/poky/meta-poky \
  /sources/meta-openembedded/meta-oe \
  /sources/meta-openembedded/meta-python \
  /sources/meta-openembedded/meta-networking \
  /sources/meta-qt6 \
  "
```

Let's add our own layer for the adaptions via

```
bitbake-layers create-layer ../meta-coffee
```

We can remore the folder recipes-examples.
As we use meta-qt6 content in the layer, it should depend on it in the layer.conf

```
...
LAYERDEPENDS_meta-coffee = "core qt6-layer"
...
```

And add it to the bblayers.conf via
```
bitbake-layers add-layer ../meta-coffee
```

### Coffeemachine executable

The coffeemachine is included in the qtdoc sources and gets packaged into the qtdoc-examples.
As also all the other examples would be included in this package, we will create our own
package only containing this package in a bbappend,.

```
PACKAGE_BEFORE_PN =+ "qtdoc-coffee"
PACKAGES =+ "qtdoc-coffee"
FILES:qtdoc-coffee = "\
    ${QT6_INSTALL_EXAMPLESDIR}/demos/coffee \
    ${systemd_unitdir}/system/ \
"
```
### Systemd service

Next we want to start the coffeemachine automatically on boot, so we will need a systemd service:

```
[Unit]
Description=Coffeemachine

[Service]
ExecStart=/usr/share/examples/demos/coffee/coffeemachine

[Install]
WantedBy=multi-user.target
```

And add it to our package in the bbappend

```
FILESEXTRAPATHS:prepend := "${THISDIR}/qtdoc:"

inherit systemd

SYSTEMD_SERVICE_${PN}-coffee = "coffee.service"
SRC_URI:append = " file://coffee.service "

do_install:append() {
    install -d ${D}/${systemd_unitdir}/system/multi-user.target.wants/
    install -m 0644 ${WORKDIR}/coffee.service ${D}/${systemd_unitdir}/system
    ln -sf ${D}/${systemd_unitdir}/system/coffee.service ${D}/${systemd_unitdir}/system/multi-user.target.wants/coffee.service 
}
```

### coffee-machine image

For adding our own image we can create a file minimal-coffee.bb that inherits the core-image class
```
inherit core-image
"
```

As we do not want to enter login credentials, we will enable autlogin:

```
IMAGE_FEATURES += "\
        debug-tweaks \
        "

inherit core-image

LOCAL_GETTY ?= " \
    ${IMAGE_ROOTFS}${systemd_system_unitdir}/serial-getty@.service \
    ${IMAGE_ROOTFS}${systemd_system_unitdir}/getty@.service \
"
local_autologin () {
    sed -i -e 's/^\(ExecStart *=.*getty \)/\1--autologin root /' ${LOCAL_GETTY}
}
ROOTFS_POSTPROCESS_COMMAND += "local_autologin"
```

Last we need to add our cofee package and some needed dependencies:

```
IMAGE_INSTALL += "\
    weston \
    qtimageformats \
    qtsvg \
    qtdoc-coffee \
"
```

### local conf

To build this imaage we will need to accept some commercial qt licnenses....

```
LICENSE_FLAGS_ACCEPTED = "\
    commercial_gstreamer1.0-libav \
    commercial_gstreamer1.0-plugins-ugly \
    commercial_faad2 \
"
```

As we used systemd to start the coffee machine and also use wayland etc. we also
need to enable this in the local.conf

```
DISTRO_FEATURES += "systemd wayland opengl usrmerge pam"
INIT_MANAGER = "systemd"
```

### Build the image

With this we can build the image via

```
bitbake minimal-coffee
```

And start it e.g. in QEMU

```
 runqemu  qemuparams="--enable-kvm -m 8G -smp 8" 
```

