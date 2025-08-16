## LostIP

A Tor-driven IP shuffler tailored for ethical hackers and privacy researchers. LostIP automates IP rotation through Tor at your specified intervals, using SOCKS5 on port **9050** to mask your traffic effortlessly.

---

### Highlights

- Installs required tools (`Tor`, `curl`, `jq`) if missing.
- Rotates your IP address on demand.
- Reveals each new Tor-assigned IP and its geolocation (country, region, city).
- Offers both finite runs (custom cycle count) and continuous mode.
- Cleans up by shutting down Tor on exit or interruption.
- Configures SOCKS5 proxy pointing to `127.0.0.1:9050`.

---

### Prerequisites

- A Debian-based Linux OS (examples: Kali, Parrot OS, Ubuntu, etc).
- Root privileges.
- Access to the internet.

---

### Setup Steps

1. Clone repo:

   ```bash
   git clone https://github.com/RlxChap2/LostIP.git
   cd LostIP
   ```

2. Run the installer:

   ```bash
   sudo bash install.sh
   ```

   - Type `y` to confirm installation.

---

### Run It

Execute the program:

```bash
sudo lostip
```

You'll be prompted to specify:

- The delay between IP switches (in seconds).
- Number of rounds (enter `0` for endless rotation).

---

### Proxy Configuration

To route traffic through Tor:

- **Host**: `127.0.0.1`
- **Port**: `9050`
- You may apply this in your browser or other tools under SOCKS5 settings.

---

### What Happens Internally

- LostIP spins up Tor automatically.
- Each cycle, Tor resets the connection to fetch a fresh IP.
- The script prints the new IP and its location.
- When the tool exits (manually or after completing cycles), Tor is gracefully stopped.

---

### Sample Output

```
Enter rotation interval (sec) [default: 60]: 25
Enter number of cycles (0 = infinite): 3

[+] Switching Tor circuit…
[✓] IP: 51.158.68.26 — France, Île‑de‑France, Paris

[+] Switching Tor circuit…
[✓] IP: 176.10.99.100 — Germany, North Rhine‑Westphalia, Düsseldorf

[+] Switching Tor circuit…
[✓] IP: 185.220.101.5 — Czechia, Prague
```

---

### Termination

- **Continuous mode**: Use `Ctrl+C` to stop.
- **Limited mode**: The script exits after the set number of rotations.
- Tor shuts down automatically in both cases.

---

### Uninstall

```bash
cd LostIP
sudo bash install.sh
```

Select `n` to remove installation.

---

### License & Author

- Released under the **MIT License**.
- Developed by **\[RlxChap2 | 0xR1A7]**
  GitHub: `https://github.com/RlxChap2`
