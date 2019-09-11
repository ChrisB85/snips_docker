#!/bin/bash
cd "${0%/*}"

string="$(journalctl -u snips-nlu -r -n 1)"
#echo $string
dt=$(date '+%d.%m.%Y %H:%M:%S');
if [[ $string == *"ERROR:rumqtt::client"* ]]; then
  echo "$dt Restarting Snips"
  source ./snips_restart.sh
#else
#  echo "$dt OK"
fi
