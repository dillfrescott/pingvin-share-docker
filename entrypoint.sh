#!/bin/bash

cd /pingvin-share/backend

HOSTNAME=0.0.0.0 PORT=8080 npm run prod &

cd /pingvin-share/frontend

API_URL=http://localhost:8080 PORT=3333 HOSTNAME=0.0.0.0 npm run start &

caddy run --config /etc/caddy/Caddyfile &

while true; do sleep 1; done