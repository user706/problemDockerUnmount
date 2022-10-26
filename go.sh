#!/usr/bin/env bash

#set -x

SCRIPT_PATH="$(readlink -e "$BASH_SOURCE")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

IMAGE_NAME=im_one
CONTAINER_NAME=cont_one


# build image
docker build --progress=plain `#--no-cache` -t="$IMAGE_NAME" .

# mount
TARGET=$SCRIPT_DIR/target1
mkdir -p $TARGET
sudo mount --bind /tmp $TARGET

# start/enter container
docker run --rm --name $CONTAINER_NAME --mount type=bind,source="$(readlink -e $TARGET)",target=/target1,readonly -it "$IMAGE_NAME" /bin/bash -c 'ls -l /target1'

# unmount
mount | grep '/target1'  # first list mount information
#read -p "hit enter to continue and try to unmount"
sudo umount    $TARGET
sleep 1

# info
if mountpoint     $TARGET; then
    echo " - command: sudo fuser -v $SCRIPT_DIR/target1"
    sudo fuser -v $TARGET
    echo " - command: sudo lsof                 target1"
    sudo lsof                 target1
else
    echo "All good"
fi
