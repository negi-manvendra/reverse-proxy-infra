#!/usr/bin/env bash
set -euo pipefail
GREEN='\e[32m'; YELLOW='\e[33m'; RED='\e[31m'; BLUE='\e[34m'; NC='\e[0m'
info(){ echo -e "${BLUE}[INFO]${NC} $*"; }
success(){ echo -e "${GREEN}[SUCCESS]${NC} $*"; }
error(){ echo -e "${RED}[ERROR]${NC} $*"; }

info 'Installing NGINX...'
sudo apt update && sudo apt install -y nginx
success 'NGINX installed'

info 'Creating log directory...'
mkdir -p "$(pwd)/logs"
success 'Log directory ready'

info 'Copying NGINX configuration files...'
sudo cp -f "$(pwd)/nginx/nginx.conf" /etc/nginx/nginx.conf
sudo cp -f "$(pwd)/nginx/sites-available/reverse-proxy.conf" /etc/nginx/sites-enabled/reverse-proxy.conf
sudo cp -f "$(pwd)/nginx/sites-available/app1.local.conf" /etc/nginx/sites-enabled/app1.local.conf
sudo cp -f "$(pwd)/nginx/sites-available/app2.local.conf" /etc/nginx/sites-enabled/app2.local.conf

info 'Creating custom error pages...'
sudo tee /var/www/html/404.html > /dev/null <<'HTML'
<!doctype html><html><head><title>404 Not Found</title></head><body><h1>404 - Page Not Found</h1><p>Custom reverse proxy error page.</p></body></html>
HTML
sudo tee /var/www/html/500.html > /dev/null <<'HTML'
<!doctype html><html><head><title>500 Internal Error</title></head><body><h1>500 - Internal Error</h1><p>Please try again later.</p></body></html>
HTML

info 'Starting backend services...'
pkill -f 'nc -l -p 8081' 2>/dev/null || true
pkill -f 'nc -l -p 8082' 2>/dev/null || true
nohup ./backend/app1/start.sh >/tmp/app1.log 2>&1 &
nohup ./backend/app2/start.sh >/tmp/app2.log 2>&1 &

sleep 1
success 'Backend started'

info 'Testing nginx configuration...'
sudo nginx -t

info 'Reloading nginx...'
sudo systemctl reload nginx
success 'Reverse proxy is running'

cat <<EOF
========================================
Reverse Proxy Infrastructure
============================
[INFO] Setup complete
[SUCCESS] NGINX configured successfully
[SUCCESS] Reverse proxy is running
