#!/bin/bash

# --- Colors ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${CYAN}  ___________________________________________________ "
echo -e " /                                                   \\"
echo -e " |      ⚡ SOUTH VPN: THE OPEN SOURCE TUNNEL ⚡      |"
echo -e " \___________________________________________________/${NC}"
echo ""

# [1/4] Detecting server environment
echo -e "${YELLOW}[1/4] 🛰️ Detecting server environment...${NC}"
SERVER_IP=$(curl -s ifconfig.me)
if [ -z "$SERVER_IP" ]; then
    SERVER_IP="127.0.0.1"
fi
echo -e "     > Public IP found: ${GREEN}$SERVER_IP${NC}"

# [2/4] Security Setup
echo -e "${YELLOW}[2/4] 🔐 Security Setup${NC}"
read -p "     > Enter Dashboard Password (default: SouthVPN262): " PASS
PASS=${PASS:-SouthVPN262}
echo -e "     > Using password: ${GREEN}$PASS${NC}"

# [3/4] Docker Check & Install
echo -e "${YELLOW}[3/4] 🐳 Checking Docker Engine...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "     > Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl start docker
    systemctl enable docker
fi

# [4/4] Deploying South VPN
echo -e "${YELLOW}[4/4] 🚀 Deploying South VPN...${NC}"
mkdir -p ~/south-vpn && cd ~/south-vpn

cat <<EOF > docker-compose.yml
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

docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock docker/compose:latest up -d

echo ""
echo -e "${GREEN}✅ INSTALLATION COMPLETE!${NC}"
echo -e "🌐 Dashboard: http://${SERVER_IP}:51821"
echo -e "🔑 Password: ${PASS}"
echo ""
