docker rm -f snips

docker run --rm --init -it \
--name="snips" \
--network containers_default \
-v /etc/asound.conf  \
-v /usr/share/snips/assistant \
-v /dev/snd:/dev/snd \
-v ${PWD}/config/snips.toml:/etc/snips.toml \
--cap-add SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
snips
