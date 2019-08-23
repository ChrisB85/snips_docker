docker rm -f snips

# Create config dir
CONFIG_DIR=${PWD}/config
mkdir -p $CONFIG_DIR
touch $CONFIG_DIR/asound.conf
touch $CONFIG_DIR/snips.toml
touch $CONFIG_DIR/snips.toml.default

if [ ! -f $CONFIG_DIR/snips/googlecredentials.json ]; then
    echo "WARNING! googlecredentials.json not found! Please download it from https://console.cloud.google.com and place in $CONFIG_DIR/snips"
    exit
fi

docker run -d \
--name=snips \
--network containers_default \
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

docker exec -it snips /bin/sh /scripts/init.sh
