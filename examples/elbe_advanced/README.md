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


libQt6Qml.so -> qt6-declarative-dev
libQt6Gui.so.6 -> libqt6gui6
libQt6Core.so.6 -> 	libqt6core6
libstdc++.so.6 -> libstdc++6
libgcc_s.so.1 -> libgcc-s1
libc.so.6 -> libc6

