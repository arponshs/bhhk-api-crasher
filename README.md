<div align="center">

```
██████╗ ██╗  ██╗██╗  ██╗██╗  ██╗    █████╗ ██████╗ ██╗
██╔══██╗██║  ██║██║  ██║██║ ██╔╝   ██╔══██╗██╔══██╗██║
██████╔╝███████║███████║█████╔╝    ███████║██████╔╝██║
██╔══██╗██╔══██║██╔══██║██╔═██╗    ██╔══██║██╔═══╝ ██║
██████╔╝██║  ██║██║  ██║██║  ██╗   ██║  ██║██║     ██║
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝

        ⚡  A P I   C R A S H E R  ⚡
        High-Performance Stress Engine
```

![Version](https://img.shields.io/badge/version-2.0-ff2d95?style=for-the-badge&labelColor=05060f)
![Platform](https://img.shields.io/badge/platform-Termux-00f0ff?style=for-the-badge&labelColor=05060f)
![License](https://img.shields.io/badge/license-MIT-b829ff?style=for-the-badge&labelColor=05060f)
![Status](https://img.shields.io/badge/status-active-00ff88?style=for-the-badge&labelColor=05060f)

</div>

---

## ✨ Overview

**BHHK API CRASHER** is a lightweight, high-speed API stress testing tool built specifically for **Termux** on Android. It allows developers and security researchers to benchmark, load-test, and analyze the resilience of their own web APIs under heavy traffic conditions.

Built with pure **Bash** and **cURL** — no heavy dependencies, no external servers, no data collection. Everything runs locally on your device.

---

## 🎯 Key Features

<table>
<tr>
<td width="50%">

### ⚡ Performance
- Multi-threaded request engine
- Configurable thread pools (10 / 25 / 50)
- Non-blocking async workers
- Optimized for mobile CPUs
- Zero-lag rendering

</td>
<td width="50%">

### 📊 Monitoring
- Real-time request log
- Live success/fail counters
- Requests-per-second meter
- Latency tracking (ms)
- HTTP status code capture

</td>
</tr>
<tr>
<td>

### 🎨 Interface
- Neon-styled terminal UI
- Animated boot sequence
- Smooth progress bars
- Color-coded log output
- Clean, readable layout

</td>
<td>

### 🛡️ Reliability
- Auto timeout handling
- Connection retry logic
- Cache-bypass headers
- Graceful shutdown (Ctrl+C)
- Session isolation

</td>
</tr>
</table>

---

## 📦 Installation

### Prerequisites

Make sure you have **Termux** installed from [F-Droid](https://f-droid.org/en/packages/com.termux/) or GitHub. The Play Store version is outdated.

### Step-by-Step Setup

**1. Update package list and install Git:**

```bash
pkg update && pkg upgrade -y
pkg install git -y
```

**2. Clone the repository:**

```bash
git clone https://github.com/arponshs/bhhk-api-crasher.git
cd bhhk-api-crasher
```

**3. Run the installer:**

```bash
bash install.sh
```

**4. Launch the tool:**

```bash
bhhk
```

That's it — installation is fully automated.

---

## 🚀 Usage Guide

### Basic Flow

```bash
$ bhhk
```

You'll be greeted with the main menu:

```
  ╭──────────────────────────────────────────╮
  │  [1]  ⚡  START ATTACK                      │
  │  [2]  📊  STATISTICS                        │
  │  [3]  📖  HELP / INFO                       │
  │  [0]  🚪  EXIT                              │
  ╰──────────────────────────────────────────╯
```

### Step 1 — Enter Target URL

```
  ▸ Enter target API URL
    Example: api.example.com/v1/data
  ➜ 
```

Just paste your API endpoint. HTTPS is auto-detected and added if missing.

### Step 2 — Select Thread Count

| Option | Threads | Use Case |
|:------:|:-------:|----------|
| **1** | 10 | Light load — safe for testing |
| **2** | 25 | Medium load — moderate stress |
| **3** | 50 | Heavy load — maximum pressure |

### Step 3 — Watch the Live Log

```
  12:45:01 [OK]   W3   124ms 200
  12:45:01 [OK]   W7    89ms 200
  12:45:01 [ERR]  W12  8001ms TIMEOUT
  12:45:01 [OK]   W5   156ms 200
```

Each line shows:
- **Timestamp** — when the request finished
- **Status** — OK or ERR
- **Worker ID** — which thread sent it
- **Latency** — response time in milliseconds
- **HTTP Code** — server response

### Step 4 — Stop the Attack

Press **`Ctrl + C`** (in Termux: **Volume Down + C**) to stop. A summary will appear:

```
  ╔══════════════════════════════════════════╗
  ║   ⏹  ATTACK STOPPED                        ║
  ╚══════════════════════════════════════════╝

  ▸ Success:  1247
  ▸ Failed:   83
  ▸ Total:    1330
```

---

## 🎨 Interface Preview

<div align="center">

```
    ╔══════════════════════════════════════════╗
    ║  ⚡  B H H K   A P I   C R A S H E R  ⚡    ║
    ║      Stress Engine v2.0                  ║
    ╚══════════════════════════════════════════╝

  ▸ OK:1247  ERR:83  TOTAL:1330  REQ/s:287
  ──────────────────────────────────────────
  12:45:01 [OK]   W3   124ms 200
  12:45:01 [OK]   W7    89ms 200
  12:45:01 [ERR]  W12  8001ms TIMEOUT
  12:45:01 [OK]   W5   156ms 200
```

</div>

---

## 📁 File Structure

```
bhhk-api-crasher/
├── README.md          → Documentation
├── install.sh         → Automated installer
└── bhhk.sh            → Main engine
```

Runtime files are stored in `~/.bhhk_crasher/` (safe to delete anytime).

---

## 🔧 Configuration

You can tweak these values at the top of `bhhk.sh`:

```bash
TIMEOUT=8          # Request timeout in seconds
THREADS=10         # Default thread count
```

| Variable | Default | Description |
|----------|---------|-------------|
| `TIMEOUT` | 8 | Max wait time per request |
| `THREADS` | 10 | Default workers on startup |

---

## ❓ Troubleshooting

<details>
<summary><b>Command "bhhk" not found</b></summary>

Run `source ~/.bashrc` or restart Termux. If still failing:

```bash
ls -la $PREFIX/bin/bhhk
```

If the file doesn't exist, re-run `bash install.sh`.
</details>

<details>
<summary><b>Nothing happens on START</b></summary>

Check your internet connection:

```bash
curl -I https://google.com
```

Also verify cURL is installed:

```bash
curl --version
```
</details>

<details>
<summary><b>Log not showing</b></summary>

Make sure you're on the latest version. Re-pull from GitHub:

```bash
cd bhhk-api-crasher
git pull
bash install.sh
```
</details>

<details>
<summary><b>Ctrl+C doesn't work</b></summary>

In Termux, press **Volume Down + C** together. Or swipe from the left edge to open the extra keys row.
</details>

<details>
<summary><b>Permission denied</b></summary>

Fix file permissions manually:

```bash
chmod +x bhhk.sh install.sh
```
</details>

---

## 🎓 Best Practices

### ✅ DO

- ✔ Test APIs you own or have written permission to test
- ✔ Start with low thread counts (10) before scaling up
- ✔ Monitor the target server's response — look for rate limits
- ✔ Use it for load testing, benchmarking, or bug hunting
- ✔ Record latency trends to spot performance regressions

### ❌ DON'T

- ✘ Attack public APIs you don't own — illegal in most jurisdictions
- ✘ Use against government, banking, or critical infrastructure
- ✘ Overload shared networks or shared hosting platforms
- ✘ Ignore the HTTP 429 (rate limit) responses
- ✘ Leave it running unattended for long periods

---

## 🔒 Legal Disclaimer

```
┌──────────────────────────────────────────────────────────┐
│  This tool is provided for EDUCATIONAL and ETHICAL       │
│  purposes only. The author assumes NO responsibility     │
│  for misuse, damage, or legal consequences arising       │
│  from the use of this software.                          │
│                                                          │
│  By using BHHK API CRASHER, you agree that:              │
│                                                          │
│    • You will only test systems you own or are           │
│      explicitly authorized to test.                      │
│    • You understand that unauthorized attacks are        │
│      illegal and may result in criminal charges.         │
│    • You take full responsibility for your own actions.  │
└──────────────────────────────────────────────────────────┘
```

---

## 🛠️ Technical Details

| Aspect | Detail |
|--------|--------|
| **Language** | Bash 4.0+ |
| **HTTP Engine** | cURL |
| **Concurrency** | Background processes (`&`) |
| **Log Mechanism** | Per-worker atomic files |
| **Rate Meter** | 1-second rolling window |
| **Timeout** | `--max-time` + `--connect-timeout` |
| **Headers** | Custom User-Agent + no-cache |
| **Cache Bypass** | `_cb=<random>` query param |

---

## 🗺️ Roadmap

- [x] Multi-threaded engine
- [x] Live log terminal
- [x] Real-time stats
- [x] Cache bypass
- [ ] POST / PUT method support
- [ ] Custom headers injection
- [ ] JSON body payload
- [ ] Export results to CSV
- [ ] Proxy rotation support
- [ ] Scheduled attacks
- [ ] Telegram notification on completion

---

## 🤝 Contributing

Contributions are welcome. To contribute:

1. Fork the repository
2. Create a feature branch — `git checkout -b feature/amazing`
3. Commit changes — `git commit -m 'Add amazing feature'`
4. Push branch — `git push origin feature/amazing`
5. Open a Pull Request

Please keep code clean, commented, and tested on Termux.

---

## 📜 License

Released under the **MIT License**.

```
Copyright (c) 2025 BHHK

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software.
```

See [LICENSE](LICENSE) for full text.

---

## 📞 Contact & Support

<div align="center">

**Developer:** [@arponshs](https://github.com/arponshs)

**Repository:** [github.com/arponshs/bhhk-api-crasher](https://github.com/arponshs/bhhk-api-crasher)

**Issues:** [Report a bug](https://github.com/arponshs/bhhk-api-crasher/issues)

**Telegram:** [@BHHKTEAMS](https://t.me/BHHKTEAMS)

</div>

---

<div align="center">

```
╔══════════════════════════════════════════════════╗
║                                                  ║
║   ⚡  Built with precision. Tested with care.  ⚡  ║
║                                                  ║
║              ★  B H H K  ★                       ║
║                                                  ║
╚══════════════════════════════════════════════════╝
```

**⭐ If this tool helped you, give it a star! ⭐**

Made with 💙 in Bangladesh

</div>