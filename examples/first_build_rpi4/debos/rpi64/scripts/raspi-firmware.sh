#!/bin/bash


echo 'ROOTPART="LABEL=root"' >> /etc/default/raspi-firmware
echo 'KERNEL_ARCH="arm64"' >> /etc/default/raspi-firmware
echo 'init=/usr/lib/systemd/systemd' >> /etc/default/raspi-extra-cmdline

# regenerate config
update-initramfs -u -k all
