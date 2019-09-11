# Base image
FROM ubuntu:18.04
#FROM raspbian/stretch

# Config
ENV S_USER='pi' \
    S_PASSWORD='raspberry' \
    S_SSH_HOST='localhost'

# Timezone
ENV TZ 'Europe/Warsaw'

# Let OS know that we're a docker container
ENV container docker

# Environment variables for apt
ENV DEBIAN_FRONTEND noninteractive

# Install
#   systemd, logrotate and unattended-upgrades
RUN apt-get update; \
    apt-get install -y systemd logrotate unattended-upgrades locales; \
    apt-get clean

# Keep journal in memory, max 50M
RUN sed -i 's#^.\(Storage\).*#\1=volatile#' /etc/systemd/journald.conf; \
    sed -i 's#^.\(RuntimeMaxUse\).*#\1=50M#' /etc/systemd/journald.conf

# Forward journal to console
RUN sed -i 's#^.\(ForwardToConsole\).*#\1=yes#' /etc/systemd/journald.conf

# Remove interactive prompt on console
RUN systemctl mask getty.target

# Stop systemd
STOPSIGNAL SIGRTMIN+3

# Mount these volumes
VOLUME /run /run/lock /tmp /sys/fs/cgroup

# When exec to docker, start in /root
WORKDIR /root

# Install extra packages on start
ENTRYPOINT ["/scripts/entrypoint.sh"]

# Start with systemd
CMD exec /sbin/init

RUN apt-get install -y dirmngr apt-transport-https software-properties-common dialog apt-utils ca-certificates
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F727C778CCB0A455
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D4F50CDCA10A2849

RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections
RUN echo "deb https://debian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list
#RUN echo "deb https://raspbian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list

# Set timezone
RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

# Set locale
COPY ${PWD}/scripts/set_locale.sh /scripts/set_locale.sh
RUN /scripts/set_locale.sh && echo "source /scripts/set_locale.sh" >> /root/.bashrc

# Requirements
RUN apt-get install -y openssh-server sudo zip git mpg123 httpie alsa-utils alsa-tools nodejs npm \
    python3 python3-pip python3-venv 

# Keep home directory on sudo
RUN echo 'Defaults env_keep -= "HOME"' > /etc/sudoers.d/sudoers

# Python requirements
RUN pip3 install python-dateutil virtualenv toml

# MQTT server
RUN apt-get install -y mosquitto

# Snips SAM
RUN npm install -g snips-sam

# Snips packages
RUN apt-get update
RUN apt-get install -y \
snips-platform-common=0.61.1 \
snips-analytics=0.61.1 \
snips-audio-server=0.61.1 \
snips-dialogue=0.61.1 \
snips-hotword=0.61.1 \
snips-injection=0.61.1 \
snips-nlu=0.61.1 \
snips-skill-server=0.61.1 \
snips-template=0.61.1 \
snips-tts=0.61.1 \
snips-watch=0.61.1 \
snips-asr-google=0.60.12

RUN apt-mark hold \
snips-platform-common \
snips-analytics \
snips-audio-server \
snips-dialogue \
snips-hotword \
snips-injection \
snips-nlu \
snips-skill-server \
snips-template \
snips-tts \
snips-watch \
snips-asr-google

# Default config backup
RUN cp /etc/snips.toml /etc/snips.toml.bak
RUN cp -r /etc/mosquitto /etc/mosquitto.bak
RUN cp -r /var/lib/snips /var/lib/snips.bak

# Others
RUN apt-get install -y mc rsyslog

# Scripts
COPY ${PWD}/scripts /scripts

# Cron
RUN touch /var/log/cron.log
#RUN chown www-data:www-data /var/log/cron.log
COPY /scripts/cron /etc/cron.d/cron
RUN crontab /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron
RUN service cron reload
