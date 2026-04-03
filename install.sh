#!/bin/bash

# Setup variabili
SERVER_IP=$(curl -s ifconfig.me)
PASS="SouthVPN262"

echo "------------------------------------------"
echo "🚀 INSTALLING SOUTH VPN..."
echo "------------------------------------------"

# Installazione pacchetti necessari
sudo apt-get update
sudo apt-get install -y docker.io docker-compose curl

# Creazione cartella di lavoro
mkdir -p ~/south-vpn
cd ~/south-vpn

# Creazione del file di configurazione
cat <<EOF > docker-compose.yml
version: '3'
services:
  wg-easy:
    environment:
      - WG_HOST=${SERVER_IP}
      - PASSWORD=${PASS}
    image: weejewel/wg-easy
    container_name: south-vpn
    volumes:
      - ./.wg-easy:/etc/wireguard
    ports:
      - "51820:51820/udp"
      - "51821:51821/tcp"
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    restart: unless-stopped
EOF

# Avvio del servizio
sudo docker-compose up -d

echo "------------------------------------------"
echo "✅ SETUP COMPLETATO!"
echo "🌐 Dashboard: http://${SERVER_IP}:51821"
echo "🔑 Password: ${PASS}"
echo "------------------------------------------"
