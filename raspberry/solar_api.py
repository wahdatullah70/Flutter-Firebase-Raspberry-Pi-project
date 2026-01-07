#!/usr/bin/env python3
"""raspberry.solar_api
Simple, well-structured Flask server that exposes solar/telemetry data for
the Flutter mobile app in this repository.

This module provides a tiny API and example data generator. It's intentionally
minimal so you can replace the 'read_sensors' function with real sensor code
on the Raspberry Pi (GPIO, I2C, SPI, etc.).

Usage (dev):

1. Create a virtualenv (recommended):

   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt

2. Run locally for development:

   python3 solar_api.py

3. Production (example using gunicorn):

   gunicorn -b 0.0.0.0:5000 solar_api:app

Endpoints:
- GET /data  -> JSON object with timestamp, power_w, battery_v, status

"""
from __future__ import annotations

import os
import time
import random
from typing import Dict

from flask import Flask, jsonify, request

app = Flask(__name__)


def read_sensors() -> Dict[str, object]:
    """Return a sample telemetry dict.

    Replace this implementation with real sensor reads on the Pi. Keep the
    returned shape stable so the Flutter client can parse it.
    """
    return {
        "timestamp": int(time.time()),
        "power_w": round(100 + 30 * random.random(), 1),
        "battery_v": round(12 + 1.5 * random.random(), 2),
        "status": random.choice(["OK", "LOW_BATTERY", "FAULT"]),
    }


@app.route("/data")
def data():
    """API: return current telemetry as JSON.

    The client expects keys: `timestamp`, `power_w`, `battery_v`, `status`.
    """
    expected = os.environ.get("SOLAR_API_TOKEN")
    if expected:
        provided = request.headers.get("X-API-Key", "")
        if provided != expected:
            return jsonify({"error": "unauthorized"}), 401

    sample = read_sensors()
    return jsonify(sample)


if __name__ == "__main__":
    print("Starting solar_api (development server) on 0.0.0.0:5000")
    # Do NOT use the Flask debug server in production; use gunicorn instead.
    app.run(host="0.0.0.0", port=5000, debug=False)
