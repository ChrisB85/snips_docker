docker rm -f snips

docker run \
--name="snips" \
--network containers_default \
-v /etc/asound.conf  \
-v /usr/share/snips/assistant \
-v /dev/snd:/dev/snd \
-v ${PWD}/config/snips.toml:/etc/snips.toml \
--privileged \
-e APT= --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
snips
