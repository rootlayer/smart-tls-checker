#!/bin/bash

# smart_tls_check.sh
# Scans TLS versions and ciphers using Nmap and gives security recommendations

BOLD=$(tput bold)
RESET=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

read -rp "🔍 Enter domain or IP to scan: " TARGET

# Check dependencies
if ! command -v nmap &> /dev/null; then
  echo "${RED}❌ Nmap is not installed. Please install it first.${RESET}"
  exit 1
fi

echo -e "\n🔎 Running TLS scan on ${TARGET} ...\n"
nmap --script ssl-enum-ciphers -p 443 "$TARGET" > .tls_scan_tmp.txt

if [[ ! -s .tls_scan_tmp.txt ]]; then
  echo "${RED}❌ No output from Nmap. Check the domain/IP and try again.${RESET}"
  exit 1
fi

# ------------ TLS version detection ------------
echo -e "${BOLD}🔐 Supported TLS versions:${RESET}"
TLS_VERSIONS=$(grep -oE "TLSv[0-9.]+:" .tls_scan_tmp.txt | sort -u)
for ver in $TLS_VERSIONS; do
  case $ver in
    TLSv1.0:|TLSv1.1:)
      echo -e "  ${RED}${ver}  (Insecure – ❌)${RESET}" ;;
    TLSv1.2:|TLSv1.3:)
      echo -e "  ${GREEN}${ver}  (Secure – ✅)${RESET}" ;;
    *)
      echo -e "  ${YELLOW}${ver}  (Unknown – ⚠️)${RESET}" ;;
  esac
done

# ------------ Weak ciphers detection (fixed) ------------
echo -e "\n${BOLD}🔎 Insecure or weak cipher suites:${RESET}"

# Only grep cipher lines, not compressors
WEAK_CIPHERS=$(grep -Ei "^\s+(TLS|SSL)_" .tls_scan_tmp.txt | grep -Ei "RC4|3DES|NULL|EXPORT|MD5")
CBC_TLS_OLD=$(awk '/TLSv1\.[01]:/,/^$/' .tls_scan_tmp.txt | grep -Ei "CBC")

WEAK=false

if [[ -n "$WEAK_CIPHERS" || -n "$CBC_TLS_OLD" ]]; then
  echo -e "${YELLOW}⚠️  The following weak ciphers were found:${RESET}"
  [[ -n "$WEAK_CIPHERS" ]] && echo "$WEAK_CIPHERS" | sed 's/^/  🔸 /'
  [[ -n "$CBC_TLS_OLD" ]] && echo "$CBC_TLS_OLD" | sed 's/^/  🔸 /'
  WEAK=true
else
  echo -e "${GREEN}✅ No weak ciphers detected.${RESET}"
fi

# ------------ Cipher strength rating ------------
RATING=$(grep -oE 'least strength: [A-Z]' .tls_scan_tmp.txt | awk '{print $3}')
if [[ -n "$RATING" ]]; then
  echo -e "\n${BOLD}📊 Cipher strength rating:${RESET}"
  case $RATING in
    A) echo -e "${GREEN}✅ Rating: A (Strong)${RESET}" ;;
    B|C) echo -e "${YELLOW}⚠️  Rating: $RATING (Moderate)${RESET}" ;;
    D|F) echo -e "${RED}❌ Rating: $RATING (Weak)${RESET}" ;;
    *) echo -e "Rating: $RATING" ;;
  esac
fi

# ------------ Recommendations ------------
echo -e "\n${BOLD}📋 Recommendation:${RESET}"

if echo "$TLS_VERSIONS" | grep -q "TLSv1.0:\|TLSv1.1:"; then
  echo -e "${RED}❌ Disable TLS 1.0 and 1.1 – they are deprecated.${RESET}"
fi

if [[ "$WEAK" == true ]]; then
  echo -e "${RED}❌ Remove weak ciphers (CBC on TLS <1.2, RC4, NULL, EXPORT, etc.) from config.${RESET}"
fi

if ! echo "$TLS_VERSIONS" | grep -q "TLSv1.3:"; then
  echo -e "${YELLOW}⚠️  Consider enabling TLS 1.3 for stronger security and performance.${RESET}"
fi

if [[ "$WEAK" == false && ! "$TLS_VERSIONS" =~ "TLSv1.0" && "$RATING" == "A" ]]; then
  echo -e "${GREEN}✅ No action needed. TLS configuration looks secure.${RESET}"
fi

# ------------ Save output ------------
echo -e "\n📁 Full scan saved to: .tls_scan_tmp.txt"

