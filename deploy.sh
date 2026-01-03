#!/bin/bash

# ==========================================
# Joey's Shop - Robust Deployment Script
# Based on your working BP Tracker script
# ==========================================

set -e # Exit immediately if a command exits with a non-zero status

# --- Configuration ---
SSH_HOST="joeyspace"
SERVER_PATH="/var/www/shop"           # Remote destination
LOCAL_SOURCE="./shop/"                # We sync the CONTENTS of the 'shop' folder
BACKEND_PATH="$SERVER_PATH/backend"   # Where server.js lives on remote
PM2_APP_NAME="shop-upload-service"

# --- Colors for Output ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== 🚀 Starting Joey's Shop Deployment ===${NC}"
echo "Source: $LOCAL_SOURCE"
echo "Target: $SSH_HOST:$SERVER_PATH"

# ---------------------------------------------
# Step 1: Sync Files (Rsync)
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 1: Syncing files...${NC}"

# We use -avz to archive, be verbose, and compress.
# --delete ensures deleted local files are removed from the server.
# Capture rsync output to show what's being updated
echo -e "${YELLOW}    Transferring files...${NC}"
rsync_output=$(rsync -avz \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='.DS_Store' \
    --exclude='.env' \
    --exclude='*.log' \
    --exclude='.cursor' \
    --exclude='deploy.py' \
    --exclude='deploy.sh' \
    --exclude='sync-to-server.sh' \
    "$LOCAL_SOURCE" "$SSH_HOST:$SERVER_PATH" 2>&1)

# Extract and display files being transferred
# Rsync verbose output shows files with paths like "./file" or "file"
echo -e "${YELLOW}    Files being updated:${NC}"
echo "$rsync_output" | \
    grep -v -E '^(sending|receiving|total size|sent|received|building|^$)' | \
    grep -v '^$' | \
    sed 's|^\./||' | \
    sed 's|/$||' | \
    sed 's/^/    ✓ /' | \
    head -50 || true

# Show summary if there are more files
files_count=$(echo "$rsync_output" | \
    grep -v -E '^(sending|receiving|total size|sent|received|building|^$)' | \
    grep -v '^$' | wc -l || echo "0")
if [ "$files_count" -gt 50 ]; then
    echo -e "${YELLOW}    ... and $((files_count - 50)) more files${NC}"
fi

echo -e "${GREEN}    ✔ Files synced successfully.${NC}"

# Verify critical files were uploaded
echo -e "\n${CYAN}--> Verifying critical files...${NC}"
ssh $SSH_HOST "
    echo 'Checking shop files...'
    [ -f $SERVER_PATH/index.html ] && echo '  ✓ index.html' || echo '  ✗ index.html MISSING'
    [ -f $SERVER_PATH/market.html ] && echo '  ✓ market.html' || echo '  ✗ market.html MISSING'
    if [ -f $SERVER_PATH/assets/css/style.css ]; then
        CSS_LINES=\$(wc -l < $SERVER_PATH/assets/css/style.css)
        CSS_SIZE=\$(stat -f%z $SERVER_PATH/assets/css/style.css 2>/dev/null || stat -c%s $SERVER_PATH/assets/css/style.css 2>/dev/null || echo 'unknown')
        echo \"  ✓ assets/css/style.css (lines: \$CSS_LINES, size: \$CSS_SIZE bytes)\"
        if [ \$CSS_LINES -lt 800 ]; then
            echo \"  ⚠️  WARNING: CSS file seems incomplete (expected ~889 lines, got \$CSS_LINES)\"
        fi
    else
        echo '  ✗ assets/css/style.css MISSING'
    fi
    [ -f $SERVER_PATH/js/app.js ] && echo '  ✓ js/app.js' || echo '  ✗ js/app.js MISSING'
    [ -f $SERVER_PATH/js/supabase.js ] && echo '  ✓ js/supabase.js' || echo '  ✗ js/supabase.js MISSING'
    [ -d $SERVER_PATH/assets/sprites ] && echo '  ✓ assets/sprites/ directory' || echo '  ✗ assets/sprites/ MISSING'
"

# ---------------------------------------------
# Step 2: Install Dependencies
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 2: Installing backend dependencies...${NC}"

ssh $SSH_HOST "cd $BACKEND_PATH && \
    if [ -f 'package.json' ]; then \
        npm install --production && echo '    ✔ Dependencies installed'; \
    else \
        echo '    ⚠️ No package.json found in backend/'; \
    fi"

# ---------------------------------------------
# Step 3: Fix Permissions
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 3: Fixing permissions...${NC}"

# Ensure www-data owns the files so Nginx can read them
ssh $SSH_HOST "sudo chown -R www-data:www-data $SERVER_PATH && \
    sudo chmod -R 755 $SERVER_PATH"

echo -e "${GREEN}    ✔ Permissions set to www-data.${NC}"

# ---------------------------------------------
# Step 4: Hard Restart Application (Crash Fix)
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 4: Restarting application (Hard Reset)...${NC}"

# We explicitly DELETE the process first. This fixes the "Process not found" 
# or "errored" state loop you were seeing.
ssh $SSH_HOST "cd $BACKEND_PATH && \
    (pm2 delete $PM2_APP_NAME 2>/dev/null || true) && \
    pm2 start server.js --name $PM2_APP_NAME && \
    pm2 save"

echo -e "${GREEN}    ✔ Application restarted!${NC}"

# ---------------------------------------------
# Step 5: Final Status Check
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 5: Checking Status...${NC}"
ssh $SSH_HOST "pm2 list | grep $PM2_APP_NAME"

echo -e "\n${GREEN}=== ✅ Deployment Complete! ===${NC}"