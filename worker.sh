#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

cd "$SCRIPT_PATH"

sh scripts/embeds.sh embeds embeds.html embeds_head.html

echo 'Executing setup...'
sh scripts/set.sh docs/parser.conf index.html
sh scripts/set.sh docs/parser.conf embeds.html
sh scripts/set.sh docs/parser.conf search.js
sh scripts/set.sh docs/parser.conf tor/index.html
sh scripts/set.sh docs/parser.conf i2p/index.html
sh scripts/set.sh docs/parser.conf about-me/index.html
sh scripts/set.sh docs/parser.conf README.md

rm -f .gitignore
