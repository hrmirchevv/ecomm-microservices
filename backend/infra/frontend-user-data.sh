#!/bin/bash
set -e

dnf update -y
dnf install -y nginx nodejs git

systemctl enable nginx
systemctl start nginx

mkdir -p /opt/frontend
chown ec2-user:ec2-user /opt/frontend
cd /opt/frontend

# Clone monorepo
sudo -u ec2-user git clone https://github.com/hrmirchevv/ecomm-microservices.git

cd /frontend
sudo -u ec2-user npm install
sudo -u ec2-user npm run build

rm -rf /usr/share/nginx/html/*
cp -r dist/* /usr/share/nginx/html/

systemctl restart nginx
