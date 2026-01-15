#!/bin/bash
# ----------------------------------------
# EC2 bootstrap for all NestJS microservices
# ----------------------------------------

# Update system
dnf update -y

# Install Git and Node.js
dnf install -y git
dnf install -y nodejs

# Install PM2 globally
npm install -g pm2

# App base directory
mkdir -p /opt/apps
chown ec2-user:ec2-user /opt/apps
cd /opt/apps

# Clone repo if not exists
if [ ! -d "backend" ]; then
  sudo -u ec2-user git clone https://github.com/hrmirchevv/ecomm-microservices.git backend
fi

cd backend/apps

# Array of services and ports
declare -A services
services=( ["customers-service"]=3000 ["subscriptions-service"]=3001 ["auth-service"]=3002 )

# Loop over each service
for service in "${!services[@]}"; do
  PORT=${services[$service]}
  cd /opt/apps/backend/apps/$service || continue

  # Install dependencies and build
  sudo -u ec2-user npm install
  sudo -u ec2-user npm run build

  # Start with PM2
  sudo -u ec2-user pm2 start dist/main.js --name $service --watch -- --port $PORT
done

# Make PM2 survive reboot
sudo -u ec2-user pm2 startup systemd -u ec2-user --hp /home/ec2-user
sudo -u ec2-user pm2 save
