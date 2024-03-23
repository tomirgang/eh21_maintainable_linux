FILESEXTRAPATHS:prepend := "${THISDIR}/qtdoc:"

inherit systemd

SYSTEMD_SERVICE_${PN}-coffee = "coffee.service"
SRC_URI:append = " file://coffee.service "

DEPENDS:remove = "\
    qtcharts \
    qtgraphs \
    qtlocation \
    qtmultimedia \
    qtpositioning \
    qtqick3d \
    qtquick3d-native \
    qtsensors \
    qtshadertools-native \
    qtwebsockets \
    qtquick3dphysics\
"

do_install:append() {
    install -d ${D}/${systemd_unitdir}/system/multi-user.target.wants/
    install -m 0644 ${WORKDIR}/coffee.service ${D}/${systemd_unitdir}/system
    ln -sf ${D}/${systemd_unitdir}/system/coffee.service ${D}/${systemd_unitdir}/system/multi-user.target.wants/coffee.service 
}

PACKAGE_BEFORE_PN =+ "qtdoc-coffee"
FILES:qtdoc-coffee = "\
    ${QT6_INSTALL_EXAMPLESDIR}/demos/coffee \
    ${systemd_unitdir}/system/ \
"
