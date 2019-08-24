#!/bin/bash

LANG_NEW="pl_PL"
LANG_ENCODING="UTF-8"
LANG_SYMBOL="$LANG_NEW.$LANG_ENCODING"
LOCALE_ENCODING="$LANG_NEW.utf8"

perl -pi -e 's/# '$LANG_SYMBOL' UTF-8/'$LANG_SYMBOL' UTF-8/g' /etc/locale.gen

if !( locale -a | grep -q "$LOCALE_ENCODING"); then
    locale-gen $LANG_SYMBOL
fi

export LANGUAGE=$LANG_SYMBOL
export LC_ALL=$LANG_SYMBOL
export LANG=$LANG_SYMBOL
update-locale LANG=$LANG_SYMBOL
