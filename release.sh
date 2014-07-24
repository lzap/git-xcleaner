#!/bin/bash
set -xe
tito build --tgz
FROM=/tmp/tito/git-xcleaner*tar.gz
TO_HOST=lzap@fedorapeople.org
TO_DIR=/home/fedora/lzap/public_html/projects/git-xcleaner/
ssh $TO_HOST "mkdir -p $TO_DIR || true"
rsync -av -e ssh $FROM $TO_HOST:$TO_DIR
