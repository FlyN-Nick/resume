#!/usr/bin/env sh
set -eu

date="${BUILD_DATE:-$(date -u +%F)}"
ai_security_b="build/nicholas-assaderaghi-resume-${date}.pdf"
ai_security_m="build/nicholas-assaderaghi-resume-masters-${date}.pdf"
ai_ml_b="build/nicholas-assaderaghi-resume-ai-ml-research-${date}.pdf"
ai_ml_m="build/nicholas-assaderaghi-resume-ai-ml-research-masters-${date}.pdf"
security_b="build/nicholas-assaderaghi-resume-security-engineering-${date}.pdf"
security_m="build/nicholas-assaderaghi-resume-security-engineering-masters-${date}.pdf"
software_b="build/nicholas-assaderaghi-resume-software-ml-engineering-${date}.pdf"
software_m="build/nicholas-assaderaghi-resume-software-ml-engineering-masters-${date}.pdf"

for pdf in "$ai_security_b" "$ai_security_m" "$ai_ml_b" "$ai_ml_m" \
  "$security_b" "$security_m" "$software_b" "$software_m"; do
  test -s "$pdf"
  test "$(pdfinfo "$pdf" | awk '/^Pages:/ {print $2}')" -eq 1
done

ai_security_bt="$(mktemp)"; ai_security_mt="$(mktemp)"
ai_ml_bt="$(mktemp)"; ai_ml_mt="$(mktemp)"
security_bt="$(mktemp)"; security_mt="$(mktemp)"
software_bt="$(mktemp)"; software_mt="$(mktemp)"
trap 'rm -f "$ai_security_bt" "$ai_security_mt" "$ai_ml_bt" "$ai_ml_mt" "$security_bt" "$security_mt" "$software_bt" "$software_mt"' EXIT

pdftotext "$ai_security_b" "$ai_security_bt"; pdftotext "$ai_security_m" "$ai_security_mt"
pdftotext "$ai_ml_b" "$ai_ml_bt"; pdftotext "$ai_ml_m" "$ai_ml_mt"
pdftotext "$security_b" "$security_bt"; pdftotext "$security_m" "$security_mt"
pdftotext "$software_b" "$software_bt"; pdftotext "$software_m" "$software_mt"

for text_file in "$ai_security_bt" "$ai_ml_bt" "$security_bt" "$software_bt"; do
  grep -F 'Bachelor' "$text_file"
  grep -F 'Projects & Publications' "$text_file"
  grep -F 'SRE-Bench: A Realistic, Contamination-Free RE Benchmark' "$text_file"
  grep -F 'arXiv:2608.11469' "$text_file"
  grep -F 'Vals AI' "$text_file"
  grep -F 'Docker' "$text_file"
  grep -F 'Tools & Frameworks:' "$text_file" | grep -Fq ', SQL,'
  grep -F 'Tools & Frameworks:' "$text_file" | grep -Fq ', S3,'
  tr '\n' ' ' < "$text_file" | grep -Fq 'Season V US Cyber Combine Athlete'
  if grep -Fq 'Master' "$text_file"; then
    printf '%s\n' "error: bachelor's resume must not contain master's content" >&2
    exit 1
  fi
done

for text_file in "$ai_security_mt" "$ai_ml_mt" "$security_mt" "$software_mt"; do
  grep -F "Master's Degree in Computer Science" "$text_file"
  grep -F 'Sept 2026' "$text_file"
  grep -F 'May 2028' "$text_file"
  master_line="$(grep -n -F "Master's Degree in Computer Science" "$text_file" | head -n 1 | cut -d: -f1)"
  bachelor_line="$(grep -n -F "Bachelor's Degree in Computer Science" "$text_file" | head -n 1 | cut -d: -f1)"
  coursework_line="$(grep -n -F 'Coursework:' "$text_file" | head -n 1 | cut -d: -f1)"
  test "$master_line" -lt "$bachelor_line"
  test "$bachelor_line" -lt "$coursework_line"
done

for text_file in "$ai_security_bt" "$ai_security_mt"; do
  grep -F 'Malware Analysis, Compilers' "$text_file"
  grep -F 'and task validation' "$text_file"
  grep -F 'cryptocurrency-wallet transfer backdoor' "$text_file"
  if grep -Fq 'memorAIs' "$text_file"; then
    printf '%s\n' 'error: AI-security edition must omit the memorAIs project' >&2
    exit 1
  fi
done

for text_file in "$ai_ml_bt" "$ai_ml_mt"; do
  grep -F 'LLM-as-judge evaluation methodology' "$text_file"
  if grep -Fq 'memorAIs' "$text_file"; then
    printf '%s\n' 'error: AI/ML research edition must omit the memorAIs project' >&2
    exit 1
  fi
done

for text_file in "$security_bt" "$security_mt"; do
  grep -F 'controlled Claude Code security benchmark' "$text_file"
  grep -F 'cryptocurrency-wallet transfer backdoor' "$text_file"
  if grep -Fq 'memorAIs' "$text_file"; then
    printf '%s\n' 'error: security-engineering edition must omit the memorAIs project' >&2
    exit 1
  fi
done

for text_file in "$software_bt" "$software_mt"; do
  grep -F 'standardized task validation' "$text_file"
  grep -F 'memorAIs' "$text_file"
  if grep -Fq 'cryptocurrency-wallet transfer backdoor' "$text_file"; then
    printf '%s\n' 'error: software/ML edition must omit the security-challenge detail' >&2
    exit 1
  fi
done

for text_file in "$ai_security_bt" "$ai_security_mt" "$ai_ml_bt" "$ai_ml_mt" \
  "$security_bt" "$security_mt" "$software_bt" "$software_mt"; do
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
