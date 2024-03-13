# Advanced elbe examples

## Build app with custom QT

Inspired by https://wiki.qt.io/Cross-Compile_Qt_6_for_Raspberry_Pi

### Get QT6

- Checkout submodules: `git submodule update --init --recursive -j 8`

### Get cross-compile SDK

In folder `examples/elbe_advanced/image`:

- Build image and SDK: `elbe initvm submit --skip-build-sources --skip-build-bin --build-sdk rpi-image/aarch64_rpi4_qt6.xml`

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

- Change to app build folder: `examples/elbe_advanced/coffee-build-cross`
- Ensure that it's not a symlinked folder: `cd $(realpath ${PWD})`
- Prepare build: `./../qt6/qt-raspi/bin/qt-cmake ../coffee_v6.6.2/CMakeLists.txt`
- Build app: `cmake --build . --parallel 8`

This will generate a binary `coffee` in `examples/elbe_advanced/qt6/qt5/qtdoc/examples/demos/coffee`

### Test the app

- Mount the SD card and change to the root folder.
- Create the QT6 library folder: `sudo mkdir -p /usr/local/qt6`
- Copy the content of `examples/elbe_advanced/qt6/qt-raspi` to `usr/local/qt6` in the mounted Raspberry Pi root filesystem.
- Copy the app binary to the Raspberry Pi root filesystem.

Unmount the SD card and boot it in the Pi. Then:

- Add QT library path: `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qt6/lib/`
- Run the app: `./coffeemachine -platform eglfs`


**Problem:** Now we would need to package our QT version and maintain it. :/

# Build app using Debian QT6 packages

Prepare elbe pbuilder environment:

Run in `examples/elbe_advanced/image` the following command:

```bash
elbe pbuilder create --xmlfile ./rpi-image/aarch64_rpi4_min.xml --writeproject pbuilder_rpi.prj --cross
```

In parallel, we can prepare the Debian metadata (already done in this git repo):

```bash
sudo apt install dh-make

export DEBFULLNAME="Thomas Irgang"
export DEBEMAIL="thomas@irgang.eu"

dh_make -n -s --yes
```

And then finetune the generated metadata in `examples/elbe_advanced/coffee-6.4.2/debian`.

The project id was saved as `examples/elbe_advanced/image/pbuilder_rpi.prj`.
Add this value as environment variable: `export PRJ=$(cat pbuilder_rpi.prj)`.

Now we can build the Debian package:

Change to folder `examples/elbe_advanced/coffee-6.4.2` and run:

```bash
elbe pbuilder build --cross --project $PRJ
```

[ERROR]Package fails to build.
Please make sure, that the submitted package builds in pbuilder
Traceback (most recent call last):
  File "/usr/lib/python3/dist-packages/elbepack/elbeproject.py", line 787, in pdebuild_build
    do('cd '
  File "/usr/lib/python3/dist-packages/elbepack/shellhelper.py", line 255, in do
    raise CommandError(cmd, p.returncode)
elbepack.shellhelper.CommandError: Error: 1 returned from Command cd "/var/cache/elbe/6c99d28d-6cd4-4c79-a5a7-df09879e2dc9/pdebuilder/current";dpkg-source -b .;  pbuilder build --host-arch arm64 --configfile "/var/cache/elbe/6c99d28d-6cd4-4c79-a5a7-df09879e2dc9/cross_pbuilderrc" --basetgz "/var/cache/elbe/6c99d28d-6cd4-4c79-a5a7-df09879e2dc9/pbuilder_cross/base.tgz" --buildresult "/var/cache/elbe/6c99d28d-6cd4-4c79-a5a7-df09879e2dc9/pbuilder_cross/result" ../*.dsc
[CMD] reprepro --basedir "/var/cache/elbe/6c99d28d-6cd4-4c79-a5a7-df09879e2dc9/repo" export bookworm
[INFO]Pdeb finished with Error
Project build was not successful, current status: build_failed
elbe control wait_busy Failed
Giving up






