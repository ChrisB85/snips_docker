#!/bin/bash
cd "${0%/*}"

./fix_permissions.sh
sam update-assistant
./snips_pl.sh

