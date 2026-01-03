#!/bin/bash

# ==========================================
# Joey's Shop - Smart Sync to Server (Fix applied)
# ==========================================

set -e

# Get script directory to resolve paths correctly (handles WSL)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_SHOP_DIR="$SCRIPT_DIR/shop"

# Configuration
SERVER_PATH="/var/www/shop"
SSH_HOST="joeyspace"
BACKEND_PATH="$SERVER_PATH/backend"
PM2_APP_NAME="shop-upload-service"

# 1. Parse Arguments
FORCE_UPLOAD=false
for arg in "$@"; do
  if [ "$arg" == "--force" ]; then
    FORCE_UPLOAD=true
    shift
  fi
done

echo "=== 🚀 Starting Joey's Shop Deployment ==="
if [ "$FORCE_UPLOAD" = true ]; then
    echo "⚠️  FORCE MODE: Uploading all files, ignoring standard exclusions."
    # FIX: Use parentheses to create an empty ARRAY, not a string
    EXCLUDES=() 
else
    echo "Mode: Standard (Selective Sync)"
    # Standard exclusion list
    EXCLUDES=(
        --exclude='node_modules/'
        --exclude='.git/'
        --exclude='*.sql'
        --exclude='.env'
        --exclude='.env.local'
        --exclude='.env.*.local'
        --exclude='*.log'
        --exclude='logs/'
        --exclude='.cursor/'
        --exclude='*.md'
        --exclude='*.sh'
        --exclude='.gitignore'
        --exclude='package-lock.json'
    )
fi

echo "Source: $LOCAL_SHOP_DIR"
echo "Target: $SSH_HOST:$SERVER_PATH"

# Verify shop directory exists
if [ ! -d "$LOCAL_SHOP_DIR" ]; then
    echo "❌ ERROR: shop/ directory not found: $LOCAL_SHOP_DIR"
    echo ""
    echo "This script is for deploying the shop application."
    echo "If you're trying to deploy the portfolio, use: ./deploy-portfolio.sh"
    echo ""
    echo "Current directory: $(pwd)"
    echo "Script directory: $SCRIPT_DIR"
    echo ""
    echo "Looking for shop directory at: $LOCAL_SHOP_DIR"
    echo "Available directories:"
    ls -d */ 2>/dev/null | head -10 || echo "  (none found)"
    exit 1
fi

# 0. Clean up old nested shop directory
echo ""
echo "--> Step 0/6: Cleaning up old nested directories..."
ssh $SSH_HOST "sudo rm -rf $SERVER_PATH/shop 2>/dev/null || true"

# 0.5 PRE-FLIGHT: Reclaim Ownership
echo ""
echo "--> Step 0.5/6: Reclaiming directory ownership for rsync..."
ssh $SSH_HOST "sudo chown -R \$USER:\$USER $SERVER_PATH"

# 1. Sync Application Files
echo ""
echo "--> Step 1/6: Syncing shop application files..."

# Change to script directory to use relative paths (avoids WSL path issues)
ORIGINAL_DIR="$(pwd)"
cd "$SCRIPT_DIR" || {
    echo "❌ ERROR: Failed to change to script directory"
    exit 1
}

# Verify shop directory exists from here
if [ ! -d "shop" ]; then
    echo "❌ ERROR: shop/ directory not found in $SCRIPT_DIR"
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Use relative path to avoid WSL path conversion issues
rsync -avzc \
    --rsync-path="sudo rsync" \
    "${EXCLUDES[@]}" \
    shop/ $SSH_HOST:$SERVER_PATH/

RSYNC_EXIT=$?

# Return to original directory
cd "$ORIGINAL_DIR" || exit 1

if [ $RSYNC_EXIT -ne 0 ]; then
    echo "❌ ERROR: Rsync failed with exit code: $RSYNC_EXIT"
    exit 1
fi

# 1b. Verify Critical Files Synced
echo ""
echo "--> Step 1b/6: Verifying critical files..."
ssh $SSH_HOST "cd $SERVER_PATH && \
    if [ -f 'index.html' ]; then echo '    ✅ index.html exists'; else echo '    ❌ ERROR: index.html MISSING!'; exit 1; fi && \
    if [ -f 'backend/package.json' ]; then echo '    ✅ backend/package.json exists'; else echo '    ❌ ERROR: backend/package.json MISSING!'; exit 1; fi"

# 2. Remote Build & Install
echo ""
echo "--> Step 2/6: Installing backend dependencies..."
ssh $SSH_HOST "cd $BACKEND_PATH && \
    if [ -f 'package.json' ]; then \
        npm install --production && echo '    - Dependencies installed'; \
    else \
        echo '    ❌ ERROR: package.json not found!'; exit 1; \
    fi"

# 3. Set Permissions (Handing off to www-data)
echo ""
echo "--> Step 3/6: Setting final permissions (www-data)..."
ssh $SSH_HOST "cd $SERVER_PATH && \
    sudo chown -R www-data:www-data . && \
    sudo find . -type f -exec chmod 644 {} \; && \
    sudo find . -type d -exec chmod 755 {} \; && \
    sudo chmod +x backend/server.js 2>/dev/null || true && \
    echo '    - Permissions locked to www-data'"

# 4. Restart Application
echo ""
echo "--> Step 4/6: Restarting backend service..."
ssh $SSH_HOST "cd $BACKEND_PATH && \
    pm2 delete $PM2_APP_NAME 2>/dev/null || true && \
    pm2 start ecosystem.config.js --name $PM2_APP_NAME && \
    pm2 save"

# 5. Final Checks
echo ""
echo "--> Step 5/6: Final verification..."
PM2_STATUS=$(ssh $SSH_HOST "pm2 list | grep $PM2_APP_NAME || echo 'NOT_FOUND'")
if [[ "$PM2_STATUS" == *"NOT_FOUND"* ]]; then
    echo "⚠️  WARNING: PM2 process not found!"
else
    echo "✅ PM2 process is running."
fi

echo ""
echo "=== ✅ Deployment Complete! ==="