# Raspberry Pi API (solar_api)

This folder contains a tiny Flask-based REST API that simulates solar/telemetry
data for the Flutter mobile app in this project.

Quick start
1. Create and activate a Python virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

2. Install dependencies:

```bash
pip install -r requirements.txt
```

3. Run the dev server:

```bash
python3 solar_api.py
```

Production: use `gunicorn -b 0.0.0.0:5000 solar_api:app` or a system service.

Notes
- Replace the `read_sensors()` implementation in `solar_api.py` with real
  Raspberry Pi sensor reads (GPIO, I2C, SPI, etc.).
- The API exposes `/data` returning JSON with `timestamp`, `power_w`,
  `battery_v`, and `status` keys.
