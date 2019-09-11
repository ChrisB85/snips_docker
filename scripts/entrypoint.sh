#!/bin/bash

service cron start

ln -s /lib/systemd/systemd /sbin/init
#service rsyslog start
if [ ! systemctl is-active --quiet ssh]; then
    service ssh start
fi

getent passwd $S_USER > /dev/null 2&>1
if [ ! $? -eq 0 ]; then
    useradd -m -p $(openssl passwd -1 $S_PASSWORD) $S_USER
    echo "$S_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$S_USER
fi

TTS_CACHE_DIR='/usr/share/snips/tts_cache'
if [ ! -d $TTS_CACHE_DIR ]; then
    mkdir $TTS_CACHE_DIR
    chmod 777 $TTS_CACHE_DIR
fi

EMPTY_DIR='/var/empty'
if [ ! -d $EMPTY_DIR ]; then
    mkdir $EMPTY_DIR
    chmod 777 $EMPTY_DIR
fi

exec "$@"
