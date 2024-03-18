# Advanced elbe examples

## Build app using Debian QT6 packages

We can build our app using the QT packages from our choosen base distribution. This approach has the drawback that we have no choice which QT version to use, but we also don't need to maintain our own QT version and get the security maintenance "for free".

Debian Bookworm is providing QT 6.4.2.

### Build the app for the host environment

For this part we will use the coffee demo app of QT 6.4.2 from https://github.com/qt/qtdoc/tree/6.4.2/examples/demos/coffee.
This app source is contained in `examples/elbe_advanced/coffee-6.4.2`. 

First we need to install the build dependencies:

```bash
sudo apt install qt6-base-dev qt6-declarative-dev
```

Now we can build the app:

```bash
cd examples/elbe_advanced
mkdir build
cd build
cmake ../coffee-6.4.2/
make
```

This should create a `coffee` binary in the build folder, which you can run on your host machine.

The most easy way to build the app for our image and the target CPU architecture is to package it using `pbuilder`.

### Package the app using pbuilder

Install pbuilder: `sudo apt install pbuilder debootstrap devscripts`

Our example image `examples/elbe_advanced/image/rpi-image/aarch64_rpi4.xml` is configured to use Debian Bookworm.

We can configure pbuilder to build for this distribution using a `.pbuilderrc` file.

```bash
echo "DISTRIBUTION=bookworm" >> ~/.pbuilderrc
echo "MIRRORSITE=http://ftp.de.debian.org/debian" >> ~/.pbuilderrc
```

To enable cross-compilation, we need to configure the apt dependency resolution: 

```bash
echo 'PBUILDERSATISFYDEPENDSCMD="/usr/lib/pbuilder/pbuilder-satisfydepends-apt"' >> ~/.pbuilderrc
```

To build the app package, we need to create Debian package metadata.
We use `dh_make` from package `dh-make` to generate the metadata:

```bash
# install needed package
sudo apt install dh-make

# change to app folder - the name must be <package name>-<package version>
cd examples/elbe_advanced/coffee-6.4.2

# set the expected environment metadata describing the maintainer
export DEBFULLNAME="Thomas Irgang"
export DEBEMAIL="thomas@irgang.eu"

# generate the matadata
dh_make -n -s --yes
```

Next we need to finetune the generated metadata in `examples/elbe_advanced/coffee-6.4.2/debian`.

At least, we should complete the `debian/control` file.
For building the QT6 coffee example app, we need to add the following additional build dependencies:

- qt6-base-dev
- qt6-declarative-dev

We also need to add the dynamic loaded app dependencies. The coffee app relies on:

- qml6-module-qtquick
- qml6-module-qtquick-controls
- qml6-module-qtquick-layouts
- qml6-module-qtquick-templates
- qml6-module-qtquick-window
- qml6-module-qtqml-workerscript

Now we can build the package by running `pdebuild` in folder `examples/elbe_advanced/coffee-6.4.2`.
This will build package for the host CPU architecture.
The build results are stored in `/var/cache/pbuilder/result`.

### Cross-build the package for aarch64

We can build for our target CPU architecutre _arm64_ in a similar way:

```bash
pdebuild -- --host-arch arm64
```

The resulting package is also stored in `/var/cache/pbuilder/result`.

### Tipps

- In case of build issues, uncomment the line `export DH_VERBOSE = 1` in `examples/elbe_advanced/coffee-6.4.2/debian/rules` to enable additional build logs.
- You can inspect the content of the resulting package with `dpkg-deb`: `dpkg-deb -c /var/cache/pbuilder/result/coffee_6.4.2_arm64.deb`
- You can install the host package using: `sudo dpkg -i /var/cache/pbuilder/result/coffee_6.4.2_amd64.deb`

# Install the app

The new app package and it's configuration is added to `examples/elbe_advanced/image/rpi-image/aarch64_rpi4.xml` using the variant _app_.

This variant adds the following changes:
- Add package _coffee_.
- Add an overlay containing a Systemd unit file which runs the app as a service.
- Use finetuning to:
    - enable the new _coffee service_
    - disable _getty@tty1_, which would render a login screen on the HDMI screen.

This time, we will use the lower level _elbe control_ commands, to be able to add our debian package to the elbe project bevor running the build.

```bash
# create a new elbe project, and save the ID as my.prj
elbe control create_project > my.prj
# make the elbe project ID available as environment variable
export PRJ=$(cat my.prj)
# preprocess the XML - this hashes the password and generates the right variant
# the result is gz compressed
elbe preprocess --variant app rpi-image/aarch64_rpi4.xml
# upload the XML to the initvm project
elbe control set_xml $PRJ preprocess.xml
# upload our binary coffee Debian package to the initvm
elbe prjrepo upload_pkg $PRJ /var/cache/pbuilder/result/coffee_6.4.2_arm64.deb
# upload our source coffee Debian package to the initvm (for sources ISO)
cd ..
elbe prjrepo upload_pkg $PRJ /var/cache/pbuilder/result/coffee_6.4.2.dsc
cd image
# list all available packages for this project - not needed, just for info
elbe prjrepo list_packages $PRJ
# trigger rebuild - this will run a background build
elbe control build $PRJ
# watch build logs an wait till build is finished
elbe control wait_busy $PRJ
# create a folder for the build results
mkdir elbe-build-result
# download build all build results
elbe control get_files --output elbe-build-result $PRJ
```

## Check the image

We can confirm that our app is contained by local mounting the image.

```bash
cd elbe-build-result
# detecet image partitions - will make loop0p1 and loop0p2 available
# p1 is boot, p2 is root
sudo losetup --partscan --find --show sdcard.img
# create mount point
mkdir root
# mount the root filesystem
sudo mount /dev/loop0p2 ${PWD}/root
```

No we can check if the binary is available: `find ./root -name "coffee" 2>/dev/null`

This should result in the following output:

```bash
./usr/share/doc/coffee
./usr/examples/coffee
```

Inspect the binary: `file ./root/usr/examples/coffee`

```bash
./usr/examples/coffee: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (GNU/Linux), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, BuildID[sha1]=e498c5152eddf1c44085a6b9c275021da89e5d6e, for GNU/Linux 3.7.0, stripped
```

And unmount the disk:

```bash
# unmount the partition
sudo umount ${PWD}/root
# unmount the image
sudo losetup -D
```

# Build app with latest QT

Inspired by https://wiki.qt.io/Cross-Compile_Qt_6_for_Raspberry_Pi

### Get QT6

- Checkout submodules: `git submodule update --init --recursive -j 8`

### Get cross-compile SDK

In folder `examples/elbe_advanced/image`:

- Build image and SDK: `elbe initvm submit --skip-build-sources --skip-build-bin --build-sdk --variant qt6_sdk rpi-image/aarch64_rpi4.xml`

- Install SDK:
    - cd `elbe-build-*`
    - `chmod +x setup-elbe-sdk-aarch64-linux-gnu-rpi4-image-1.0.sh`
    - `./setup-elbe-sdk-aarch64-linux-gnu-rpi4-image-1.0.sh`

### Build QT6 host tools

In folder `examples/elbe_advanced/qt6/qt-hostbuild`:

```bash
cd $(realpath ${PWD})
cmake $(realpath ../qt5/) -GNinja -DCMAKE_BUILD_TYPE=Release -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$(realpath ${PWD}/../qt-host)
cmake --build . --parallel 8
cmake --install .
```

### Build QT6 for the Raspberry Pi

#### Update toolchain.cmake

In folder `examples/elbe_advanced/qt6` run `realpath ../sdk/sysroots`,
and update the **SYSROOT_BASE** in `examples/elbe_advanced/qt6/toolchain.cmake`.

#### Build QT for target

In folder `examples/elbe_advanced/qt6/qt-raspibuild`:

Configure QT with toolchain:

```bash
cd $(realpath ${PWD})
../qt5/configure -release -opengl es2 -nomake examples -nomake tests -qt-host-path $(realpath ../qt-host) -extprefix $(realpath ../qt-raspi) -prefix /usr/local/qt6 -device linux-rasp-pi4-aarch64 -device-option CROSS_COMPILE=aarch64-linux-gnu- -- -DCMAKE_TOOLCHAIN_FILE=$(realpath ../toolchain.cmake) -DQT_FEATURE_xcb=ON -DFEATURE_xcb_xlib=ON -DQT_FEATURE_xlib=ON
```

Build QT for Raspberry Pi:

```bash
cmake --build . --parallel 8
cmake --install .
```

### Build app

- Create and change to app build folder: `examples/elbe_advanced/coffee-build-cross`
- Ensure that it's not a symlinked folder: `cd $(realpath ${PWD})`
- Prepare build: `./../qt6/qt-raspi/bin/qt-cmake ../coffee-6.6.2/CMakeLists.txt`
- Build app: `cmake --build . --parallel 8`

This will generate a binary `coffee` in `examples/elbe_advanced/coffee-build-cross`.

### Test the app

- Build image without SDK packages: `elbe initvm submit --skip-build-sources --skip-build-bin rpi-image/aarch64_rpi4.xml --variant qt6_run`
- Flash the image to an SD card.
- Mount the SD card and change to the root folder.
- Create the QT6 library folder: `sudo mkdir -p usr/local/qt6`
- Copy the content of `examples/elbe_advanced/qt6/qt-raspi` to `usr/local/qt6` in the mounted Raspberry Pi root filesystem.
- Copy the app binary to the Raspberry Pi root filesystem.

Unmount the SD card and boot it in the Pi. Then:

- Add QT library path: `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qt6/lib/`
- Run the app: `/coffee -platform eglfs`


**Problem:** Now we would need to package and maintain our custom QT version. :/
