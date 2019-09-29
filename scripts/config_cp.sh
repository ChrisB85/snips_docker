#!/bin/bash

if [  ! -s /etc/snips.toml ]; then
    cp -f /etc/snips.toml.bak /etc/snips.toml
fi

if [ ! -s /etc/snips.toml.default ]; then
    cp -f /etc/snips.toml.bak /etc/snips.toml.default
fi

if [ ! -f /etc/mosquitto/mosquitto.conf ]; then
    cp -Trf /etc/mosquitto.bak /etc/mosquitto
    service mosquitto restart
fi

if [ ! -d /var/lib/snips/skills ]; then
    cp -Trf /var/lib/snips.bak /var/lib/snips
    chown -R _snips-skills:snips-skills-admin /var/lib/snips
fi

ASR_SKILL_DIR=/var/lib/snips/skills/snips_google_asr
if [ ! -d $ASR_SKILL_DIR ]; then
    echo "Installing Google ASR..."
    git clone https://github.com/ChrisB85/snips_google_asr.git $ASR_SKILL_DIR
else
    echo "Updating Google ASR..."
    cd $ASR_SKILL_DIR && git pull
fi

service snips-skill-server restart
