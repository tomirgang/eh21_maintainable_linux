# Advanced elbe examples


## Prepare

### Get QT6

- Checkout submodules: `git submodule update --init --recursive -j 8`

### Get cross-compile SDK

In folder `examples/elbe_advanced/image`:

- Build image and SDK: `elbe initvm submit --skip-build-sources --skip-build-bin --build-sdk rpi-image/aarch64_rpi4.xml`

- Install SDK:
    - cd `elbe-build-*`
    - `chmod +x setup-elbe-sdk-aarch64-linux-gnu-rpi4-image-1.0.sh`
    - `./setup-elbe-sdk-aarch64-linux-gnu-rpi4-image-1.0.sh`

## Build QT6 host tools

In folder `examples/elbe_advanced/qt6/qt-hostbuild`:

```bash
cd $(realpath ${PWD})
cmake $(realpath ../qt5/) -GNinja -DCMAKE_BUILD_TYPE=Release -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$(realpath ${PWD}/../qt-host)
cmake --build . --parallel 8
cmake --install .
```

## Build QT6 for the Raspberry Pi

### Update toolchain.cmake

In folder `examples/elbe_advanced/qt6` run `realpath ../sdk/sysroots`,
and update the **SYSROOT_BASE** in  `examples/elbe_advanced/qt6/toolchain.cmake`.

### Build QT for target

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

# Build app

- Change to demo app folder: `examples/elbe_advanced/qt6/qt5/qtdoc/examples/demos/coffee`
- Ensure that it's not a symlinked folder: `cd $(realpath ${PWD})`
- Prepare build: `./../../../../../qt-raspi/bin/qt-cmake CMakeLists.txt`
- Build app: `cmake --build . --parallel 4`

This will generate a binary `coffeemachine` in `examples/elbe_advanced/qt6/qt5/qtdoc/examples/demos/coffee`

# Test the app

- Mount the SD card and change to the root folder.
- Create the QT6 library folder: `sudo mkdir -p /usr/local/qt6`
- Copy the content of `examples/elbe_advanced/qt6/qt-raspi` to `usr/local/qt6` in the mounted Raspberry Pi root filesystem.
- Copy the app binary to the Raspberry Pi root filesystem.

Unmount the SD card and boot it in the Pi. Then:

- Add QT library path: `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qt6/lib/`
- Run the app: `./coffeemachine -platform eglfs`


