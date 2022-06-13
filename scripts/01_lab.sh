#!/bin/bash

echo "Checking the NGINX License files:"
cd /home/ubuntu
ls
echo

echo "Create the /etc/ssl/nginx directory:"
sudo mkdir /etc/ssl/nginx
echo

echo "Copy licence files:"
cd /home/ubuntu
sudo cp nginx-repo.crt /etc/ssl/nginx/
sudo cp nginx-repo.key /etc/ssl/nginx/
cd /etc/ssl/nginx
ls
echo

echo "Download and add NGINX Signing key:"
sudo wget https://cs.nginx.com/static/keys/nginx_signing.key \
  && sudo apt-key add nginx_signing.key
echo

echo "Install the prerequisites packages:"
sudo apt-get -y install apt-transport-https lsb-release ca-certificates
echo

echo "Add the NGINX Plus repository:"
printf "deb https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" \
  | sudo tee /etc/apt/sources.list.d/nginx-plus.list
echo

echo "Download the nginx-plus apt configuration to /etc/apt/apt.conf.d:"
sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
echo

echo "Update the repository information:"
sudo apt-get update
echo

echo "Install nginx-plus package:"
sudo apt-get install -y nginx-plus
echo

echo "Start NGINX Plus:"
sudo systemctl start nginx
echo


