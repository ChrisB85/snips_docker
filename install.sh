#!/bin/bash
cd "${0%/*}"

./docker_build.sh
./docker_run.sh
./sam_setup_audio.sh
./sam_install_assistant.sh
