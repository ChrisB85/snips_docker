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
    service snips-skill-server restart
fi

