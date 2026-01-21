#!/bin/bash
set -e

# ----------------------------------------
# System setup
# ----------------------------------------
dnf update -y
dnf install -y git nodejs

npm install -g pm2

# ----------------------------------------
# App directories
# ----------------------------------------
mkdir -p /opt/apps
chown ec2-user:ec2-user /opt/apps
cd /opt/apps

# ----------------------------------------
# Clone backend repo
# ----------------------------------------
if [ ! -d "ecomm-microservices" ]; then
  sudo -u ec2-user git clone https://github.com/hrmirchevv/ecomm-microservices.git
fi

cd /opt/apps/ecomm-microservices/backend/apps

# ----------------------------------------
# ENV files (generated dynamically)
# ----------------------------------------

cat > customers-service/.env <<EOF
DB_HOST=${customers_db_host}
DB_PORT=5432
DB_USER=postres
DB_PASSWORD=postgres!
DB_NAME=customersdb
PORT=3000
EOF

cat > subscriptions-service/.env <<EOF
DB_HOST=${subscriptions_db_host}
DB_PORT=5432
DB_USER=postres
DB_PASSWORD=postgres!
DB_NAME=subscriptionsdb
PORT=3001
EOF

cat > auth-service/.env <<EOF
DB_HOST=${auth_db_host}
DB_PORT=5432
DB_USER=postres
DB_PASSWORD=postgres!
DB_NAME=authdb
PORT=3002
EOF

# ----------------------------------------
# Install & run services
# ----------------------------------------
for service in customers-service subscriptions-service auth-service; do
  cd /opt/apps/ecomm-microservices/backend/apps/$service
  sudo -u ec2-user npm install
  sudo -u ec2-user npm run build
  sudo -u ec2-user pm2 start dist/main.js --name $service
done

# ----------------------------------------
# Persist PM2 on reboot
# ----------------------------------------
sudo -u ec2-user pm2 startup systemd -u ec2-user --hp /home/ec2-user
sudo -u ec2-user pm2 save
