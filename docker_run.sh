docker rm -f snips

docker run -d \
--name="snips" \
--network containers_default \
-v /etc/asound.conf  \
-v /usr/share/snips/assistant \
-v /dev/snd:/dev/snd \
-v ${PWD}/config/snips.toml:/etc/snips.toml \
-v ${PWD}/config/snips:/usr/share/snips \
-v ${PWD}/config/mosquitto:/etc/mosquitto \
-p 1883:1883 \
--privileged \
-e APT= --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
snips

./docker_init.sh
