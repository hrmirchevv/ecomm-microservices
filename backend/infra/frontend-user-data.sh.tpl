#!/bin/bash
set -e

# Update OS and install packages
dnf update -y

dnf remove -y nodejs npm
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
dnf install -y nodejs

dnf install -y git nginx -y

# Enable Nginx
systemctl enable nginx
systemctl start nginx

# Ensure Nginx root exists
mkdir -p /usr/share/nginx/html
chown ec2-user:ec2-user /usr/share/nginx/html

# Create folder for frontend code
mkdir -p /opt/frontend
chown ec2-user:ec2-user /opt/frontend
cd /opt/frontend

# Clone repo
sudo -u ec2-user git clone https://github.com/hrmirchevv/ecomm-microservices.git

# Go into frontend folder
cd ecomm-microservices/frontend

# ----------------------------------------
# Frontend ENV (generated dynamically)
# ----------------------------------------
cat > .env <<EOF
VITE_CUSTOMERS_API=/api/customers
VITE_SUBSCRIPTIONS_API=/api/subscriptions
VITE_AUTH_API=/api/auth
EOF

cat > /etc/nginx/conf.d/api.conf <<EOF
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri /index.html;
    }

    location /api/customers/ {
        proxy_pass http://${customers_private_ip}:3000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /api/subscriptions/ {
        proxy_pass http://${subscriptions_private_ip}:3001/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /api/auth/ {
        proxy_pass http://${auth_private_ip}:3002/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

# Install dependencies and build
sudo -u ec2-user npm install
sudo -u ec2-user npm run build

# Copy build to Nginx root
rm -rf /usr/share/nginx/html/*
cp -r dist/* /usr/share/nginx/html/

# Restart Nginx
systemctl restart nginx
