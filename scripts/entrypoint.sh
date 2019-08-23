#!/bin/bash

USER='pi'
PASSWORD='raspberry'

getent passwd $USER > /dev/null 2&>1
if [ ! $? -eq 0 ]; then
    useradd -m -p $(openssl passwd -1 $PASSWORD) $USER
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER
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

