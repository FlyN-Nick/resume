#!/usr/bin/env sh
set -eu

date="${BUILD_DATE:-$(date -u +%F)}"
b="build/nicholas-assaderaghi-resume-${date}.pdf"
m="build/nicholas-assaderaghi-resume-masters-${date}.pdf"
test -s "$b" && test -s "$m"

bt="$(mktemp)"; mt="$(mktemp)"
trap 'rm -f "$bt" "$mt"' EXIT
pdftotext "$b" "$bt"; pdftotext "$m" "$mt"
grep -F '\boldsymbol{0.25\,R^2}' resume-content.tex
if grep -Fq '$>$10 XGBoost' resume-content.tex; then
  printf '%s\n' 'error: use 10+ rather than >10 for the XGBoost ensemble size' >&2
  exit 1
fi
for pdf in "$b" "$m"; do
  pdftotext -layout "$pdf" - | grep -F 'Developed an algorithm to convert OCR-extracted intake directions into accurate recurring calendar events'
done

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
  grep -F 'Established that parsing simulator logs into structured feedback outperformed both' "$text_file"
  grep -F 'Built and deployed an end-to-end ML pipeline' "$text_file"
  grep -F 'ingests Salesforce opportunity data into Snowflake' "$text_file"
  grep -F 'Plotly and Dash' "$text_file"
  grep -F '38.7% to 90.1%' "$text_file"
  grep -F '0.25 R2 increase' "$text_file"
  grep -F '10+ XGBoost' "$text_file"
  grep -F 'Monte Carlo simulation to probabilistically forecast semiannual revenue' "$text_file"
  grep -F "shifting the team's roadmap away from model spend and toward feedback engineering" "$text_file"
  grep -F 'Claude Code malware challenge' "$text_file"
  grep -F 'progressive investigative materials, verified ground truth, and LLM-as-judge evaluation criteria' "$text_file"
  grep -F 'OCR-extracted intake directions into accurate recurring calendar events' "$text_file"
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
