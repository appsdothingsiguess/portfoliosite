# Server Structure Analysis

## Current Server State

### Directory Structure
- `/var/www/joeyspace.dev/` - **Empty** (target for portfolio deployment)
- `/var/www/portfolio/` - **Has old index.html** (currently served by nginx)
- `/var/www/shop/` - Shop application
- `/var/www/apps/` - Other applications (bptracker, etc.)

### Port Usage
- **Port 3000**: `bptracker` PM2 process (PID 3678287)
- **Port 3001**: `shop-upload-service` PM2 process (PID 3565253)
- **Port 3002**: **Available** (will be used for portfolio)

### Current Nginx Configuration
- **Root**: `/var/www/portfolio` (serving static files directly)
- **Location `/`**: `try_files $uri $uri/ /index.html;`
- **Other locations**: `/apps/`, `/frontend`, `/shop`, etc.`

### PM2 Status
- `bptracker`: Running on port 3000
- `shop-upload-service`: Running on port 3001
- `portfolio`: **Not running** (will be on port 3002)

### User Permissions
- SSH user: `root`
- Has sudo access
- Can write to `/var/www/joeyspace.dev/` after `sudo chown`

## Required Changes

### 1. Deployment Target
✅ **Correct**: Deploy to `/var/www/joeyspace.dev/`
- This is the home directory for joeyspace.dev
- Currently empty, ready for deployment

### 2. PM2 Configuration
✅ **Updated**: Portfolio will run on **port 3002**
- Changed from port 3000 (conflicts with bptracker)
- Updated in `ecosystem.config.js`

### 3. Nginx Configuration
⚠️ **Needs Update**: Change from static file serving to proxy

**Current (static files):**
```nginx
root /var/www/portfolio;
location / {
    try_files $uri $uri/ /index.html;
}
```

**Required (proxy to PM2):**
```nginx
location / {
    proxy_pass http://localhost:3002;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_cache_bypass $http_upgrade;
}
```

### 4. Deployment Script
✅ **Updated**: 
- Uses absolute paths for WSL compatibility
- Deploys to `/var/www/joeyspace.dev/`
- Starts PM2 on port 3002
- Includes error checking

## Deployment Steps

1. **Run deployment script:**
   ```bash
   ./deploy-portfolio.sh
   ```

2. **Update nginx configuration:**
   ```bash
   ssh joeyspace "sudo nano /etc/nginx/sites-available/joeyspace.dev"
   # Replace the root /var/www/portfolio; and location / section
   # See portfolio/nginx-config-snippet.conf for the config
   ```

3. **Test and reload nginx:**
   ```bash
   ssh joeyspace "sudo nginx -t"
   ssh joeyspace "sudo systemctl reload nginx"
   ```

4. **Verify PM2 is running:**
   ```bash
   ssh joeyspace "pm2 list | grep portfolio"
   ssh joeyspace "pm2 logs portfolio --lines 20"
   ```

## Notes

- The old `/var/www/portfolio/` directory can be kept as backup or removed
- Port 3002 is available and won't conflict with existing services
- PM2 will run as root (same as other services)
- Files will be owned by www-data after deployment (for nginx access if needed)

