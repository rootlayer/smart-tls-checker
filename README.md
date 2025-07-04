# smart-tls-checker
 A Bash-based tool to scan and audit TLS versions and cipher suites using nmap

# 🔐 smart_tls_check.sh

A lightweight bash script to scan and analyze the **TLS/SSL configuration** of a target domain or IP.  
It uses `nmap` under the hood and gives clear, color-coded feedback on supported protocols, weak cipher suites, and recommendations for hardening.

---

## ✨ Features

- ✅ Detects supported **TLS versions** (1.0 - 1.3)
- 🔍 Identifies **weak/insecure ciphers**:
  - RC4, 3DES, NULL, EXPORT, MD5
  - CBC ciphers only if used with TLS 1.0 / 1.1
- 📋 Gives **actionable recommendations**
- 🌈 Colorful terminal output for easy reading
- 🧾 Saves full raw `nmap` output to `.tls_scan_tmp.txt`

---

## 🧰 Requirements

- `bash`
- `nmap` (version ≥ 7.6 recommended)

> 💡 On Debian-based systems:  
> `sudo apt install nmap`

---

## 🚀 Usage

```bash
chmod +x smart_tls_check.sh
./smart_tls_check.sh
