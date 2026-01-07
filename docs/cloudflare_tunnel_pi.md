# Cloudflare Tunnel (Raspberry Pi API) — Global Access

Goal: make your Raspberry Pi endpoint (`/data`) reachable from anywhere on the internet **over HTTPS**, without port forwarding.

This app expects a base URL like `https://api.yourdomain.com` and will call `GET /data`.

## Recommended: Named Tunnel + your own domain (stable URL)

### Requirements
- A domain added to your Cloudflare account (example: `example.com`)
- Raspberry Pi running your Flask API on port `5000`

### 1) Run the Pi API
On the Pi:

```bash
cd raspberry
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python3 solar_api.py
```

Make sure it listens on `0.0.0.0:5000` (this repo already does).

### 2) Install cloudflared on the Pi
Follow Cloudflare’s install instructions for your Pi OS.
Then verify:

```bash
cloudflared --version
```

### 3) Login (one time)
```bash
cloudflared tunnel login
```

### 4) Create a tunnel
```bash
cloudflared tunnel create solar-api
```

### 5) Route a DNS name to the tunnel
Choose a subdomain like `api.example.com`:

```bash
cloudflared tunnel route dns solar-api api.example.com
```

### 6) Create config file
Create `/etc/cloudflared/config.yml`:

```yaml
tunnel: solar-api
credentials-file: /home/pi/.cloudflared/<TUNNEL_ID>.json

ingress:
  - hostname: api.example.com
    service: http://localhost:5000
  - service: http_status:404
```

### 7) Run the tunnel
```bash
cloudflared tunnel run solar-api
```

### 8) Run on boot (systemd)
```bash
sudo cloudflared service install
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

Now your Pi API is globally available at:
- `https://api.example.com/data`

## Security (recommended): protect with an API key
If you expose your Pi publicly, protect it.

This repo supports an API key using environment variable `SOLAR_API_TOKEN`.

On the Pi:
```bash
export SOLAR_API_TOKEN='YOUR_SECRET_TOKEN'
python3 solar_api.py
```

Then in the Flutter app:
- Dashboard → **Set Raspberry Pi base URL**
- Set Base URL: `https://api.example.com`
- Set API key: `YOUR_SECRET_TOKEN`

## Quick test commands
From anywhere:

```bash
curl https://api.example.com/data
curl -H "X-API-Key: YOUR_SECRET_TOKEN" https://api.example.com/data
```

If you enabled the token, the first command should return `401` and the second should return JSON.
