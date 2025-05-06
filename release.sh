#!/bin/bash
set -xe
shfmt -w git-xcleaner
tito build --tgz
mv /tmp/tito/git-xcleaner*tar.gz /home/lzap/Scratch/lzap.fedorapeople.org/public_html/projects/git-xcleaner
/home/lzap/Scratch/upload
