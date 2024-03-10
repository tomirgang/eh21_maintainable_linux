#!/bin/bash

echo qemu64 > /etc/hostname

ln -s /usr/lib/systemd/systemd /sbin/init

systemctl enable systemd-networkd
