#!/bin/bash

echo "🌐 Installing South VPN..."

# Check for root privileges
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root (use sudo)"
  exit
fi

# Install Docker if not present
if ! [ -x "$(command -v docker)" ]; then
  echo "🐳 Installing Docker..."
  curl -fsSL https://get.docker.com | sh
fi

# Get Public IP automatically
SERVER_IP=$(curl -s ifconfig.me)

# Create directory
mkdir -p ~/south-vpn && cd ~/south-vpn

# Generate the Docker config
cat <<EOF > docker-compose.yml
services:
  south-vpn:
    image: weejewel/wg-easy
    container_name: south-vpn
    environment:
      - WG_HOST=${SERVER_IP}
      - PASSWORD=SouthVPNAdmin # Change this after login!
      - WG_PORT=51820
      - WG_DEFAULT_DNS=1.1.1.1
    volumes:
      - ./.wg-easy:/etc/wireguard
    ports:
      - "51820:51820/udp"
      - "51821:51821/tcp"
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
      - net.ipv4.ip_forward=1
    restart: unless-stopped
EOF

# Start the VPN
docker compose up -d

echo "------------------------------------------------"
echo "✅ South VPN is now ONLINE!"
echo "🔗 Dashboard: http://${SERVER_IP}:51821"
echo "🔑 Password: SouthVPNAdmin"
echo "------------------------------------------------"
