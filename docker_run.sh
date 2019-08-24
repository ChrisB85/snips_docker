docker rm -f snips

# Create config dir
CONFIG_DIR=${PWD}/config
mkdir -p $CONFIG_DIR
touch $CONFIG_DIR/asound.conf
touch $CONFIG_DIR/snips.toml
touch $CONFIG_DIR/snips.toml.default

docker run -d \
--name=snips \
-v /dev/snd:/dev/snd \
-v $CONFIG_DIR/asound.conf:/etc/asound.conf  \
-v $CONFIG_DIR/snips.toml:/etc/snips.toml \
-v $CONFIG_DIR/snips.toml.default:/etc/snips.toml.default \
-v $CONFIG_DIR/snips:/usr/share/snips \
-v $CONFIG_DIR/mosquitto:/etc/mosquitto \
-v $CONFIG_DIR/skills:/var/lib/snips \
-p 1883:1883 \
--privileged \
-e APT= --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
snips

if [ ! -f $CONFIG_DIR/snips/googlecredentials.json ]; then
    echo "WARNING! googlecredentials.json not found! Please go to https://console.cloud.google.com, activate Cloud Speech-to-Text API and download json auth file. Save it as $CONFIG_DIR/snips/googlecredentials.json and restart snips."
    read -p "Press any key..."
fi

docker exec -it snips /bin/sh /scripts/init.sh

echo "DONE! Now you can deploy your assistant from Snips console by running sam_install_assistant.sh. If you dont have one go to https://console.snips.ai and create it :)"
read -p "Press any key to exit..."
