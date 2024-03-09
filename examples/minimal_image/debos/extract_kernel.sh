#!/bin/bash

set -ex

mkdir -p root

sudo mount -o loop,offset=512,sizelimit=1999999488 qemu-aarch64.img ${PWD}/root

rm -f vmlinuz-*
rm -f initrd.img-*

cp ${PWD}/root/boot/vmlinuz-* .
cp ${PWD}/root/boot/initrd.img-* .

sudo umount ${PWD}/root

rm -rf ${PWD}/root
