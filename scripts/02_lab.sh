#!/bin/bash

echo "Backup default.conf:"
cd /etc/nginx/conf.d/
sudo mv default.conf default.conf.bak
echo

echo "Add Upstream servers to main.conf:"
sudo tee /etc/nginx/conf.d/main.conf << EOF
upstream myServers {
    zone http_backend 64k;
	server 10.1.1.10:8080;
	server 10.1.1.11:8080;
	server 10.1.1.12:8080;
}
EOF
echo

echo "Add server, location and logs to main.conf:"
sudo tee -a /etc/nginx/conf.d/main.conf << EOF
server {
  listen 80;
  server_name meta.com;
  root /usr/share/nginx/html;

  error_log /var/log/nginx/myServers.error.log info;
  access_log /var/log/nginx/myServers.access.log combined;

  location / {
 	proxy_pass http://myServers;
  }
}
EOF
sudo nginx -t && sudo nginx -s reload
echo


