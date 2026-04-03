#!/bin/bash

# --- Colors for the vibe ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

clear

# --- 🚀 South VPN ASCII Logo ---
echo -e "${CYAN}${BOLD}"
echo "  ___________________________________________________"
echo " /                                                   \\"
echo " |    ⚡ SOUTH VPN: THE OPEN SOURCE TUNNEL ⚡       |"
echo " \___________________________________________________/"
echo -e "${NC}"

# Check for root
if [ "$EUID" -ne 0 ]; then 
  echo -e "${GREEN}![Error]${NC} Please run this script with: sudo bash install.sh"
  exit 1
fi

echo -e "${CYAN}[1/4]${NC} 🛰️ Detecting server environment..."
SERVER_IP=$(curl -s ifconfig.me)
if [ -z "$SERVER_IP" ]; then
    SERVER_IP=$(hostname -I | awk '{print $1}')
fi
echo -e "     > Public IP found: ${BOLD}${SERVER_IP}${NC}"

echo -e "\n${CYAN}[2/4]${NC} 🔐 Security Setup"
read -p "     > Set a password for your Web Dashboard: " UI_PASS
if [ -z "$UI_PASS" ]; then
    UI_PASS="SouthVPN$(date +%s | tail -c 4)"
    echo -e "     > No password entered. Using generated: ${BOLD}$UI_PASS${NC}"
fi

echo -e "\n${CYAN}[3/4]${NC} 🐳 Checking Docker engine..."
if ! [ -x "$(command -v docker)" ]; then
    echo "     > Docker not found. Installing now..."
    curl -fsSL https://get.docker.com | sh
else
    echo "     > Docker is already installed. Skipping."
fi

echo -e "\n${CYAN}[4/4]${NC} 🏗️  Building South VPN..."
mkdir -p ~/south-vpn && cd ~/south-vpn

cat <<EOF > docker-compose.yml
services:
  south-vpn:
    image: weejewel/wg-easy
    container_name: south-vpn
    environment:
      - WG_HOST=${SERVER_IP}
      - PASSWORD=${UI_PASS}
      - WG_PORT=51820
      - WG_DEFAULT_DNS=1.1.1.1
      - WG_ALLOWED_IPS=0.0.0.0/0
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

docker compose up -d --quiet-pull

# --- Final Output ---
echo -e "\n${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✅ SOUTH VPN IS LIVE! ${NC}"
echo -e "  🌐 Dashboard: ${CYAN}http://${SERVER_IP}:51821${NC}"
echo -e "  🔑 Password:  ${BOLD}${UI_PASS}${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "  Tip: Open Port 51820 (UDP) and 51821 (TCP) in your cloud provider."
