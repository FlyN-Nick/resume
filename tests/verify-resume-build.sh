#!/usr/bin/env sh
set -eu
date="$(date -u +%F)"
b="build/nicholas-assaderaghi-resume-${date}.pdf"
m="build/nicholas-assaderaghi-resume-masters-${date}.pdf"
test -s "$b" && test -s "$m"
bt="$(mktemp)"; mt="$(mktemp)"
trap 'rm -f "$bt" "$mt"' EXIT
pdftotext "$b" "$bt"; pdftotext "$m" "$mt"
grep -F 'Bachelor' "$bt"
if grep -Fq 'Master' "$bt"; then
  printf '%s\n' "error: bachelor's resume must not contain master's content" >&2
  exit 1
fi
grep -F "Master's Degree in Computer Science" "$mt"
grep -F 'Sept 2026' "$mt"
grep -F 'May 2028' "$mt"
