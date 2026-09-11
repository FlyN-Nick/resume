#!/usr/bin/env sh
set -eu
test -f pages-dist/index.html
test -s pages-dist/index.pdf
grep -F 'data="index.pdf"' pages-dist/index.html
grep -F 'Download résumé (PDF)' pages-dist/index.html
