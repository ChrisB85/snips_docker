#!/bin/bash
cd "${0%/*}"

KEYS="/home/$S_USER/.ssh/authorized_keys"
KEY_NAME="Snips RSA key"

#if [ ! -f $KEYS ] || ! grep -q "$KEY_NAME" $KEYS; then
    ./sam_connect.sh
#else
#    echo "$KEY_NAME already exists. To change login credentials please remove it from $KEYS or run sam_connect.sh $S_SSH_HOST."
#fi
./sam_login.sh
