#FROM ubuntu:18.04
#FROM jrei/systemd-ubuntu:latest
FROM aheimsbakk/systemd-ubuntu:18.04

RUN apt-get install -y dirmngr apt-transport-https software-properties-common dialog apt-utils ca-certificates locales
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F727C778CCB0A455

RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections
RUN echo "deb https://debian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list

# Scripts
COPY ${PWD}/scripts /scripts

# Set locale
RUN /scripts/set_locale.sh
RUN echo "source /scripts/set_locale.sh" >> /root/.bashrc

RUN apt-get update

# Snips packages
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

# MQTT server
RUN apt-get install -y mosquitto

# Python
RUN apt-get install -y python3.6 python3-pip python3-venv
RUN pip3 install python-dateutil virtualenv toml

# Alsa
RUN apt-get install -y alsa-utils alsa-tools

# NodeJS
RUN apt-get install -y nodejs npm

# Snips SAM
RUN npm install -g snips-sam

# Default config backup
RUN cp /etc/snips.toml /etc/snips.toml.bak
RUN cp -r /etc/mosquitto /etc/mosquitto.bak

# SSH & requirements
RUN apt-get install -y openssh-server sudo zip git mpg123 httpie

# Keep home directory on sudo
RUN echo 'Defaults env_keep -= "HOME"' > /etc/sudoers.d/sudoers

# Others
RUN apt-get install -y mc rsyslog

# Replace default entrypoint
COPY ${PWD}/scripts/entrypoint.sh /docker-entrypoint.sh
