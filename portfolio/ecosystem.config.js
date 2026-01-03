/**
 * PM2 Ecosystem Configuration for Portfolio
 * Manages the static file server process
 * Note: This file should be renamed to ecosystem.config.cjs on the server
 * because package.json has "type": "module"
 */

module.exports = {
  apps: [{
    name: 'portfolio',
    script: './server.js',
    cwd: '/var/www/joeyspace.dev',
    instances: 1,
    exec_mode: 'fork',
    env: {
      NODE_ENV: 'production',
      PORT: 3002
    },
    error_file: '~/.pm2/logs/portfolio-error.log',
    out_file: '~/.pm2/logs/portfolio-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,
    autorestart: true,
    watch: false,
    max_memory_restart: '200M'
  }]
};

