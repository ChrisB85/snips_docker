#!/bin/bash

LANG_NEW="pl_PL"
LANG_ENCODING="utf8"
LANG_SYMBOL="$LANG_NEW.$LANG_ENCODING"

if !( locale -a | grep -q "$LANG_SYMBOL"); then
    locale-gen $LANG_SYMBOL
fi

export LANGUAGE=$LANG_SYMBOL
export LC_ALL=$LANG_SYMBOL
export LANG=$LANG_SYMBOL
update-locale
