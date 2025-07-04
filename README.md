# Smart-TLS-Checker
 A Bash-based tool to scan and audit TLS versions and cipher suites using nmap

# 🔐 smart-TLS-ciphers.sh

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
chmod +x smart-TLS-ciphers.sh
./smart-TLS-ciphers.sh
```

You’ll be prompted to enter a domain or IP:

🔍 Enter domain or IP to scan: example.com

## 📦 Sample Output

```bash
🔐 Supported TLS versions:
  TLSv1.0:  (Insecure – ❌)
  TLSv1.1:  (Insecure – ❌)
  TLSv1.2:  (Secure – ✅)
  TLSv1.3:  (Secure – ✅)

🔎 Insecure or weak cipher suites:
⚠  The following weak ciphers were found:
  🔸 |       TLS_DHE_RSA_WITH_AES_128_CBC_SHA (dh 2048) - A
  🔸 |       TLS_DHE_RSA_WITH_AES_256_CBC_SHA (dh 2048) - A
  🔸 |       TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA (dh 2048) - A
  🔸 |       TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA (dh 2048) - A
  🔸 |       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (secp256r1) - A
  🔸 |       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (secp256r1) - A
  🔸 |       TLS_RSA_WITH_AES_128_CBC_SHA (rsa 2048) - A

```


## 🔒 When to Use

Before deploying a web server (Apache, Nginx, etc.)

To harden your TLS configuration

To verify if outdated protocols or ciphers are still enabled

As part of security auditing or pentesting




