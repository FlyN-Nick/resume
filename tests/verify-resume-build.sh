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
grep -F 'Malware Analysis, Compilers' "$bt"
if grep -Fq 'Malware Analysis & Reverse Engineering' "$bt"; then
  printf '%s\n' 'error: coursework must use the shortened malware analysis label' >&2
  exit 1
fi
grep -F 'Docker' "$bt"
grep -F 'Technologies:' "$bt" | grep -Fq ', SQL,'
if grep -Fq 'PostgreSQL' "$bt"; then
  printf '%s\n' 'error: technologies must use SQL rather than PostgreSQL' >&2
  exit 1
fi
tr '\n' ' ' < "$bt" | grep -Fq 'Season V US Cyber Combine Athlete'
if grep -Fq 'Master' "$bt"; then
  printf '%s\n' "error: bachelor's resume must not contain master's content" >&2
  exit 1
fi
grep -F "Master's Degree in Computer Science" "$mt"
grep -F 'Sept 2026' "$mt"
grep -F 'May 2028' "$mt"
master_line="$(grep -n -F "Master's Degree in Computer Science" "$mt" | head -n 1 | cut -d: -f1)"
bachelor_line="$(grep -n -F "Bachelor's Degree in Computer Science" "$mt" | head -n 1 | cut -d: -f1)"
coursework_line="$(grep -n -F 'Coursework:' "$mt" | head -n 1 | cut -d: -f1)"
test "$master_line" -lt "$bachelor_line"
test "$bachelor_line" -lt "$coursework_line"
test "$(pdfinfo "$b" | awk '/^Pages:/ {print $2}')" -eq 1
test "$(pdfinfo "$m" | awk '/^Pages:/ {print $2}')" -eq 1
