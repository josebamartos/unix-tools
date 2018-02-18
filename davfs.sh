#!/usr/bin/env bash

remote="https://example.com/dav"
local="${HOME}/webdav"
uid="regular.user"
gid="user.group"

rmount() {
    echo "Mounting ${remote} into ${local}"
    sudo mount -t davfs -o rw,auto,user,uid=${uid},gid=${gid} ${remote} ${local}
}

rumount() {
    echo "Unmounting ${remote} from ${local}"
    sudo umount ${local}
}

status() {
    running=$(mount | grep ${local} | wc -l)

    if [[ "${running}" -gt 0 ]]; then
        echo "Mounted into ${local}"
    else
        echo "Not mounted"
    fi
}

case "$1" in 
    mount)  rmount  ;;
    umount) rumount ;;
    status) status ;;
    *)      echo "usage: $0 mount|umount|status" >&2
       exit 1
       ;;
esac
