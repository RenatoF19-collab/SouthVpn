Write-Host "🗺️ Installing South VPN for Windows..." -ForegroundColor Cyan

# Check for Docker
if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker Desktop is not installed. Please install it first!" -ForegroundColor Red
    return
}

# Create folder
New-Item -ItemType Directory -Force -Path "$HOME\south-vpn"
Set-Location "$HOME\south-vpn"

# Create the Docker Compose file
$ip = (Invoke-RestMethod http://ifconfig.me).Trim()
$config = @"
services:
  south-vpn:
    image: weejewel/wg-easy
    container_name: south-vpn
    environment:
      - WG_HOST=$ip
      - PASSWORD=SouthVPNAdmin
    volumes:
      - ./.wg-easy:/etc/wireguard
    ports:
      - "51820:51820/udp"
      - "51821:51821/tcp"
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
"@
$config | Out-File -FilePath docker-compose.yml -Encoding utf8

# Start
docker-compose up -d
Write-Host "✅ South VPN is running! Dashboard at http://localhost:51821" -ForegroundColor Green
