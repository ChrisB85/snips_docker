#!/bin/bash
cd "${0%/*}"
cp -r ./assistant /usr/share/snips
./snips_pl.py
sleep 1
./snips_restart.sh
