#!/bin/bash

echo "HTTPs Load Balancing"
echo
echo "Generate a self-signed certificate and key (please enter www.meta.com for FQDN):"
sudo openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
  -keyout /etc/ssl/nginx/nginx1.key -out /etc/ssl/nginx/nginx1.crt

sudo tea /etc/nginx/conf.d/https.conf << EOF
# www.meta.com HTTP Only Redirect
server {
	listen 80;
  server_name www.meta.com;

  return 301 https://$host$request_uri;
}

# www.meta.com HTTPS
server {
	listen 443 ssl default_server;
  server_name www.meta.com;

  # Minimum SSL Configuration
  ssl_certificate /etc/ssl/nginx/nginx1.crt;
  ssl_certificate_key /etc/ssl/nginx/nginx1.key;

  location / {
		proxy_pass http://myServers;
  }
}
EOF
sudo nginx -s reload
echo



