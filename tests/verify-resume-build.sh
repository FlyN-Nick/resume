#!/usr/bin/env sh
set -eu

date="${BUILD_DATE:-$(date -u +%F)}"
b="build/nicholas-assaderaghi-resume-${date}.pdf"
m="build/nicholas-assaderaghi-resume-masters-${date}.pdf"
test -s "$b" && test -s "$m"

bt="$(mktemp)"; mt="$(mktemp)"
trap 'rm -f "$bt" "$mt"' EXIT
pdftotext "$b" "$bt"; pdftotext "$m" "$mt"

for text_file in "$bt" "$mt"; do
  grep -F 'Projects & Publications' "$text_file"
  grep -F 'SRE-Bench: A Realistic, Contamination-Free RE Benchmark' "$text_file"
  grep -F 'arXiv:2608.11469' "$text_file"
  grep -F 'Vals AI' "$text_file"
  grep -F 'Malware Analysis, Artificial Intelligence, Compilers' "$text_file"
  grep -F 'Tools & Frameworks: PyTorch, Docker, SQL, S3, React, IDA, Kali Linux, Wireshark, Burp Suite, Nmap' "$text_file"
  grep -F 'Built reproducible evaluation infrastructure for agentic reverse engineering and exploitation' "$text_file"
  grep -F 'cryptocurrency-wallet transfer backdoor' "$text_file"
  grep -F 'memorAIs' "$text_file"
  if grep -Fq 'Malware Analysis & Reverse Engineering' "$text_file"; then
    printf '%s\n' 'error: coursework must use the shortened malware analysis label' >&2
    exit 1
  fi
  if grep -Fq 'PostgreSQL' "$text_file"; then
    printf '%s\n' 'error: tools must use SQL rather than PostgreSQL' >&2
    exit 1
  fi
  if grep -Fq 'Kyntic Wearable Device and App' "$text_file"; then
    printf '%s\n' 'error: Kyntic must remain in source only' >&2
    exit 1
  fi
  if grep -Fq 'Co-author' "$text_file"; then
    printf '%s\n' 'error: publication metadata line must not be included' >&2
    exit 1
  fi
done

grep -F 'Bachelor' "$bt"
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
