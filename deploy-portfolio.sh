#!/bin/bash

# ==========================================
# Portfolio Deployment Script
# Deploys Astro static site to joeyspace.dev
# ==========================================

set -e # Exit immediately if a command exits with a non-zero status

# --- Configuration ---
SSH_HOST="joeyspace"
SERVER_PATH="/var/www/joeyspace.dev"    # Remote destination (home directory)
PM2_APP_NAME="portfolio"

# Get script directory and resolve portfolio path
# Handle both regular bash and WSL paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If path starts with /c/ or /d/ etc (Windows drive in Git Bash), convert to WSL format
# Or if we're in WSL and path doesn't start with /mnt/, we might need to handle it
if [[ "$SCRIPT_DIR" =~ ^/[c-zC-Z]/ ]]; then
    # This is a Windows path format (/c/Users/...)
    # In WSL this should be /mnt/c/Users/..., but rsync might handle /c/ fine
    # Let's use the path as-is but ensure we use relative paths for rsync
    LOCAL_PORTFOLIO_DIR="$SCRIPT_DIR/portfolio"
elif [[ "$SCRIPT_DIR" =~ ^/mnt/[c-zC-Z]/ ]]; then
    # This is WSL path format (/mnt/c/Users/...)
    LOCAL_PORTFOLIO_DIR="$SCRIPT_DIR/portfolio"
else
    # Regular Linux path
    LOCAL_PORTFOLIO_DIR="$SCRIPT_DIR/portfolio"
fi

# --- Colors for Output ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== 🚀 Starting Portfolio Deployment ===${NC}"
echo "Script directory: $SCRIPT_DIR"
echo "Portfolio directory: $LOCAL_PORTFOLIO_DIR"
echo "Target: $SSH_HOST:$SERVER_PATH"

# ---------------------------------------------
# Step 0: Build the Astro site locally
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 0: Building Astro site locally...${NC}"

# Verify portfolio directory exists
if [ ! -d "$LOCAL_PORTFOLIO_DIR" ]; then
    echo -e "${RED}    ✗ Portfolio directory not found: $LOCAL_PORTFOLIO_DIR${NC}"
    echo -e "${YELLOW}    Current directory: $(pwd)${NC}"
    echo -e "${YELLOW}    Script directory: $SCRIPT_DIR${NC}"
    exit 1
fi

echo -e "${YELLOW}    Portfolio directory: $LOCAL_PORTFOLIO_DIR${NC}"

cd "$LOCAL_PORTFOLIO_DIR" || {
    echo -e "${RED}    ✗ Failed to change to portfolio directory${NC}"
    exit 1
}

if [ ! -f "package.json" ]; then
    echo -e "${RED}    ✗ package.json not found in portfolio directory${NC}"
    exit 1
fi

# Build the site
echo -e "${YELLOW}    Running: npm run build${NC}"
npm run build || {
    echo -e "${RED}    ✗ Build failed${NC}"
    exit 1
}

if [ ! -d "dist" ]; then
    echo -e "${RED}    ✗ Build failed: dist/ directory not created${NC}"
    exit 1
fi

echo -e "${GREEN}    ✔ Build completed successfully${NC}"

# Verify dist directory has content
DIST_COUNT=$(find dist -type f | wc -l)
echo -e "${YELLOW}    Built $DIST_COUNT files in dist/${NC}"

# Go back to script directory
cd "$SCRIPT_DIR" || exit 1

# ---------------------------------------------
# Step 1: Create server directory on remote
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 1: Setting up server directory...${NC}"

# Test SSH connection first
if ! ssh -o ConnectTimeout=5 $SSH_HOST "echo 'SSH connection OK'" &>/dev/null; then
    echo -e "${RED}    ✗ Cannot connect to $SSH_HOST${NC}"
    echo -e "${YELLOW}    Please check your SSH configuration${NC}"
    exit 1
fi

# Create directory and set permissions
ssh $SSH_HOST "sudo mkdir -p $SERVER_PATH && \
    sudo chown -R \$USER:\$USER $SERVER_PATH && \
    echo '    ✔ Server directory ready'" || {
    echo -e "${RED}    ✗ Failed to set up server directory${NC}"
    exit 1
}

# ---------------------------------------------
# Step 2: Sync Files (Rsync)
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 2: Syncing files to server...${NC}"

# Verify dist directory exists before syncing
if [ ! -d "$LOCAL_PORTFOLIO_DIR/dist" ]; then
    echo -e "${RED}    ✗ dist/ directory not found: $LOCAL_PORTFOLIO_DIR/dist${NC}"
    exit 1
fi

# Verify we can access the dist directory
if [ ! -d "$LOCAL_PORTFOLIO_DIR/dist" ]; then
    echo -e "${RED}    ✗ dist/ directory not found: $LOCAL_PORTFOLIO_DIR/dist${NC}"
    echo -e "${YELLOW}    Current directory: $(pwd)${NC}"
    echo -e "${YELLOW}    Script directory: $SCRIPT_DIR${NC}"
    echo -e "${YELLOW}    Portfolio directory: $LOCAL_PORTFOLIO_DIR${NC}"
    exit 1
fi

# Count files in dist to verify it's not empty
DIST_FILE_COUNT=$(find "$LOCAL_PORTFOLIO_DIR/dist" -type f | wc -l)
if [ "$DIST_FILE_COUNT" -eq 0 ]; then
    echo -e "${RED}    ✗ dist/ directory is empty${NC}"
    exit 1
fi

echo -e "${YELLOW}    Transferring dist/ files...${NC}"
echo -e "${YELLOW}    Found $DIST_FILE_COUNT files in dist/${NC}"
echo -e "${YELLOW}    Source: $LOCAL_PORTFOLIO_DIR/dist/${NC}"
echo -e "${YELLOW}    Target: $SSH_HOST:$SERVER_PATH/${NC}"

# Change to portfolio directory to use relative paths (avoids path issues)
ORIGINAL_DIR="$(pwd)"
cd "$LOCAL_PORTFOLIO_DIR" || {
    echo -e "${RED}    ✗ Failed to change to portfolio directory${NC}"
    echo -e "${YELLOW}    Tried to cd to: $LOCAL_PORTFOLIO_DIR${NC}"
    exit 1
}

# Verify we're in the right place
if [ ! -d "dist" ]; then
    echo -e "${RED}    ✗ dist/ not found after cd to portfolio directory${NC}"
    echo -e "${YELLOW}    Current directory: $(pwd)${NC}"
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Check if rsync is available
if ! command -v rsync &> /dev/null; then
    echo -e "${RED}    ✗ rsync is not installed or not in PATH${NC}"
    echo -e "${YELLOW}    Please install rsync or use WSL${NC}"
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Sync dist/ directory contents to server using relative path
# This avoids path conversion issues
echo -e "${YELLOW}    Running rsync from: $(pwd)${NC}"
echo -e "${YELLOW}    Syncing files (this may take a moment)...${NC}"

# Run rsync with timeout and capture output
# Use timeout if available, otherwise run directly
if command -v timeout &> /dev/null; then
    rsync_output=$(timeout 120 rsync -avz \
        --delete \
        --exclude='.git' \
        --exclude='.DS_Store' \
        --exclude='node_modules' \
        --exclude='.astro' \
        "dist/" "$SSH_HOST:$SERVER_PATH/" 2>&1)
else
    rsync_output=$(rsync -avz \
        --delete \
        --exclude='.git' \
        --exclude='.DS_Store' \
        --exclude='node_modules' \
        --exclude='.astro' \
        "dist/" "$SSH_HOST:$SERVER_PATH/" 2>&1)
fi

# Return to original directory
cd "$ORIGINAL_DIR" || exit 1

# Check rsync exit code
RSYNC_EXIT=$?

# Return to script directory
cd "$SCRIPT_DIR" || exit 1

if [ $RSYNC_EXIT -ne 0 ]; then
    echo -e "${RED}    ✗ Rsync failed with exit code: $RSYNC_EXIT${NC}"
    echo -e "${YELLOW}    Rsync output:${NC}"
    echo "$rsync_output"
    exit 1
fi

# Check rsync exit code
RSYNC_EXIT=$?
if [ $RSYNC_EXIT -ne 0 ]; then
    echo -e "${RED}    ✗ Rsync failed with exit code: $RSYNC_EXIT${NC}"
    echo -e "${YELLOW}    Rsync output:${NC}"
    echo "$rsync_output"
    exit 1
fi

# Extract and display files being transferred
echo -e "${YELLOW}    Files being updated:${NC}"
echo "$rsync_output" | \
    grep -v -E '^(sending|receiving|total size|sent|received|building|^$)' | \
    grep -v '^$' | \
    sed 's|^\./||' | \
    sed 's|/$||' | \
    sed 's/^/    ✓ /' | \
    head -30 || true

# Show summary if there are more files
files_count=$(echo "$rsync_output" | \
    grep -v -E '^(sending|receiving|total size|sent|received|building|^$)' | \
    grep -v '^$' | wc -l || echo "0")
if [ "$files_count" -gt 30 ]; then
    echo -e "${YELLOW}    ... and $((files_count - 30)) more files${NC}"
fi

echo -e "${GREEN}    ✔ Files synced successfully${NC}"

# ---------------------------------------------
# Step 3: Upload server files
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 3: Uploading server files...${NC}"

# Upload server.js and ecosystem.config.js
echo -e "${YELLOW}    Uploading server files...${NC}"
scp "$LOCAL_PORTFOLIO_DIR/server.js" "$SSH_HOST:$SERVER_PATH/server.js" || {
    echo -e "${RED}    ✗ Failed to upload server.js${NC}"
    exit 1
}

# Upload ecosystem.config.js and rename to .cjs (needed because package.json has "type": "module")
scp "$LOCAL_PORTFOLIO_DIR/ecosystem.config.js" "$SSH_HOST:$SERVER_PATH/ecosystem.config.cjs" || {
    echo -e "${RED}    ✗ Failed to upload ecosystem.config.js${NC}"
    exit 1
}

# Upload package.json for server dependencies
scp "$LOCAL_PORTFOLIO_DIR/package.json" "$SSH_HOST:$SERVER_PATH/package.json" || {
    echo -e "${RED}    ✗ Failed to upload package.json${NC}"
    exit 1
}

echo -e "${GREEN}    ✔ Server files uploaded${NC}"

# ---------------------------------------------
# Step 4: Install Server Dependencies
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 4: Installing server dependencies...${NC}"

ssh $SSH_HOST "cd $SERVER_PATH && \
    if [ -f 'package.json' ]; then \
        npm install --production && echo '    ✔ Dependencies installed'; \
    else \
        echo '    ⚠️  No package.json found'; \
    fi"

# ---------------------------------------------
# Step 5: Fix Permissions
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 5: Setting permissions...${NC}"

# Set ownership to www-data for web serving
ssh $SSH_HOST "sudo chown -R www-data:www-data $SERVER_PATH && \
    sudo chmod -R 755 $SERVER_PATH && \
    sudo chmod +x $SERVER_PATH/server.js 2>/dev/null || true"

echo -e "${GREEN}    ✔ Permissions set${NC}"

# ---------------------------------------------
# Step 6: Restart PM2 Application
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 6: Restarting PM2 application...${NC}"

ssh $SSH_HOST "cd $SERVER_PATH && \
    (pm2 delete $PM2_APP_NAME 2>/dev/null || true) && \
    pm2 start ecosystem.config.cjs --update-env && \
    pm2 save"

echo -e "${GREEN}    ✔ Application restarted${NC}"

# ---------------------------------------------
# Step 7: Verify Critical Files
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 7: Verifying deployment...${NC}"

ssh $SSH_HOST "
    echo 'Checking portfolio files...'
    [ -f $SERVER_PATH/index.html ] && echo '  ✓ index.html' || echo '  ✗ index.html MISSING'
    [ -f $SERVER_PATH/server.js ] && echo '  ✓ server.js' || echo '  ✗ server.js MISSING'
    [ -f $SERVER_PATH/ecosystem.config.js ] && echo '  ✓ ecosystem.config.js' || echo '  ✗ ecosystem.config.js MISSING'
    [ -d $SERVER_PATH/_astro ] && echo '  ✓ _astro/ directory' || echo '  ✗ _astro/ MISSING'
"

# ---------------------------------------------
# Step 8: Final Status Check
# ---------------------------------------------
echo -e "\n${CYAN}--> Step 8: Checking PM2 status...${NC}"
ssh $SSH_HOST "pm2 list | grep $PM2_APP_NAME || echo '  ⚠️  PM2 process not found'"

echo -e "\n${GREEN}=== ✅ Portfolio Deployment Complete! ===${NC}"
echo -e "${CYAN}Your portfolio should now be live at: https://joeyspace.dev${NC}"
echo -e "\n${YELLOW}⚠️  IMPORTANT: Update nginx configuration${NC}"
echo -e "${YELLOW}   1. Portfolio PM2 is running on port 3002${NC}"
echo -e "${YELLOW}   2. Update /etc/nginx/sites-available/joeyspace.dev${NC}"
echo -e "${YELLOW}   3. Replace 'root /var/www/portfolio;' with proxy to localhost:3002${NC}"
echo -e "${YELLOW}   4. See portfolio/nginx-config-snippet.conf for the config${NC}"
echo -e "${YELLOW}   5. Run: sudo nginx -t && sudo systemctl reload nginx${NC}"

