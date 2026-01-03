# Portfolio Deployment Guide

## Overview

This portfolio is deployed to `joeyspace.dev` using:
- **Astro** static site generator (builds to `dist/`)
- **Express** static file server (runs on port 3000)
- **PM2** process manager
- **Nginx** reverse proxy

## Prerequisites

1. SSH access to server via `joeyspace` alias
2. Node.js installed on server
3. PM2 installed globally: `npm install -g pm2`
4. Nginx configured and running

## Deployment Steps

### 1. Build and Deploy

From the project root directory:

```bash
./deploy-portfolio.sh
```

This script will:
- Build the Astro site locally (`npm run build`)
- Upload `dist/` contents to `/var/www/joeyspace.dev/`
- Upload `server.js` and `ecosystem.config.js`
- Install server dependencies
- Set proper permissions
- Start/restart PM2 process

### 2. Configure Nginx

The nginx configuration needs to proxy requests to the PM2 server on port 3000.

Update `/etc/nginx/sites-available/joeyspace.dev`:

```nginx
server {
    server_name joeyspace.dev www.joeyspace.dev;

    # SSL Configuration (if using HTTPS)
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    ssl_certificate /etc/letsencrypt/live/joeyspace.dev/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/joeyspace.dev/privkey.pem;

    # Logging
    access_log /var/log/nginx/joeyspace_access.log;
    error_log /var/log/nginx/joeyspace_error.log;

    # Proxy to PM2 server
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|webp)$ {
        proxy_pass http://localhost:3000;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

After updating nginx config:

```bash
# Test nginx configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx
```

### 3. Verify Deployment

Check PM2 status:
```bash
ssh joeyspace "pm2 list"
ssh joeyspace "pm2 logs portfolio --lines 20"
```

Check nginx:
```bash
ssh joeyspace "sudo systemctl status nginx"
```

Visit: https://joeyspace.dev

## Manual Deployment Steps

If you need to deploy manually:

```bash
# 1. Build locally
cd portfolio
npm run build

# 2. Upload files
scp -r dist/* joeyspace:/var/www/joeyspace.dev/
scp server.js joeyspace:/var/www/joeyspace.dev/
scp ecosystem.config.js joeyspace:/var/www/joeyspace.dev/
scp package.json joeyspace:/var/www/joeyspace.dev/

# 3. Install dependencies and restart
ssh joeyspace "cd /var/www/joeyspace.dev && npm install --production"
ssh joeyspace "cd /var/www/joeyspace.dev && pm2 delete portfolio 2>/dev/null || true"
ssh joeyspace "cd /var/www/joeyspace.dev && pm2 start ecosystem.config.js"
ssh joeyspace "pm2 save"

# 4. Set permissions
ssh joeyspace "sudo chown -R www-data:www-data /var/www/joeyspace.dev"
ssh joeyspace "sudo chmod -R 755 /var/www/joeyspace.dev"
```

## Troubleshooting

### PM2 Process Not Running

```bash
ssh joeyspace "pm2 list"
ssh joeyspace "pm2 logs portfolio"
ssh joeyspace "cd /var/www/joeyspace.dev && pm2 restart portfolio"
```

### Port 3000 Already in Use

```bash
ssh joeyspace "lsof -i :3000"
# Kill the process or change PORT in ecosystem.config.js
```

### Nginx 502 Bad Gateway

- Check PM2 is running: `pm2 list`
- Check server.js is accessible: `ls -la /var/www/joeyspace.dev/server.js`
- Check logs: `pm2 logs portfolio`
- Verify nginx proxy_pass points to `http://localhost:3000`

### Files Not Updating

- Ensure `dist/` directory exists locally after build
- Check rsync completed successfully
- Verify files on server: `ssh joeyspace "ls -la /var/www/joeyspace.dev/"`

## File Structure on Server

```
/var/www/joeyspace.dev/
├── index.html          # Astro build output
├── _astro/             # Astro assets
├── assets/             # Static assets
├── Images/            # Images
├── server.js          # Express static server
├── ecosystem.config.js # PM2 config
└── package.json       # Server dependencies
```

## Environment Variables

The server runs on port 3000 by default. To change:

1. Update `ecosystem.config.js`:
```js
env: {
  PORT: 3001  // or your preferred port
}
```

2. Update nginx `proxy_pass` to match

3. Restart PM2: `pm2 restart portfolio`

