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

IMAGE_INSTALL += "\
    weston \
    qtimageformats \
    qtsvg \
    qtdoc-coffee \
"
