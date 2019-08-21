#!/bin/bash

if [ ! -d "/home/pi" ]; then
    useradd -m -p $(openssl passwd -1 raspberry) pi
    echo 'pi ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/pi
fi

if grep -qs '/usr/share/snips/assistant' /proc/mounts; then
    umount /usr/share/snips/assistant
fi

exec "$@"
