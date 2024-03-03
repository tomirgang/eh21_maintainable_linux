#!/bin/bash

set -ex

mkdir -p root

sudo mount -o loop,offset=512,sizelimit=128000000 qemu-aarch64.img ${PWD}/root

rm -f vmlinuz-*
rm -f initrd.img-*

cp ${PWD}/root/vmlinuz-* .
cp ${PWD}/root/initrd.img-* .

sudo umount ${PWD}/root
