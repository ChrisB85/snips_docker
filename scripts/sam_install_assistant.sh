#!/bin/bash
cd "${0%/*}"

./fix_permissions.sh
sam install assistant
./snips_pl.sh
