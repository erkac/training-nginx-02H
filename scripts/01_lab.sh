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

echo "Install geoip2 dynamic module in nginx plus:"
sudo apt-get install nginx-plus-module-geoip2
echo

echo "Enable geoip2 dynamic module:"
sudo sed -i '7 a load_module modules/ngx_http_geoip2_module.so;' /etc/nginx/nginx.conf
sudo sed -i '8 a load_module modules/ngx_stream_geoip2_module.so;' /etc/nginx/nginx.conf
echo

echo "Reload nginx:"
sudo nginx -t && nginx -s reload
echo

echo "Create an html page as app1.html:"
sudo tee /usr/share/nginx/html/app1.html <<EOF
<!DOCTYPE html>
<html>
<body>
<h1 style="background-color:DodgerBlue;">This is App1</h1>
</body>
</html>
EOF
echo

echo "Create an html page as app2.html:"
sudo tee /usr/share/nginx/html/app2.html <<EOF
<!DOCTYPE html>
<html>
<body>
<h1 style="background-color:Green;">This is App2</h1>
</body>
</html>
EOF
echo

echo "Rename the default configuration file:"
sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
echo

echo "Create a new configuration file:"
sudo tee /etc/nginx/conf.d/web_server.conf << EOF
server {
	listen 10.1.1.10:80;
	server_name web-server-1.com;
	root /usr/share/nginx/html;

	#For logging
	access_log /var/log/nginx/map.access.log combined;
	error_log /var/log/nginx/map.error.log error;
}
EOF
echo

echo "Reload nginx:"
sudo nginx -s reload
echo

echo "Add location directive to web-server file:"
sudo tee /etc/nginx/conf.d/web_server.conf << EOF
server {
	listen 10.1.1.10:80;
	server_name web-server-1.com;
	root /usr/share/nginx/html;

	#For logging
	access_log /var/log/nginx/map.access.log combined;
	error_log /var/log/nginx/map.error.log error;

	location = /app1.html {
		root /usr/share/nginx/html;
	}
	location = /app2.html {
		root /usr/share/nginx/html;
	}
}
EOF
sudo nginx -s reload
echo

echo "Reverse Proxy Config:"
sudo mv /etc/nginx/conf.d/web_server.conf /etc/nginx/conf.d/web_server.conf.bak
sudo tee /etc/nginx/conf.d/rev_proxy.conf << EOF
server {
	listen 80;
	location /1 {
		proxy_pass http://localhost:8080;
	}

	location /2 {
		proxy_pass http://localhost:8081;
	}
}
EOF
sudo tee /etc/nginx/conf.d/app1.conf << EOF
server {
	listen 8080;
	location / {
		return 200 "I am listening on port 8080\n";
	}
}
EOF
sudo tee /etc/nginx/conf.d/app2.conf << EOF
server {
	listen 8081;
	location / {
		return 200 "I am listening on port 8081\n";
	}
}
EOF
sudo nginx -s reload
echo

echo "SSL Traffic Processing:"
sudo tee /etc/nginx/conf.d/ssl_test.conf << EOF
server {
	listen 443 ssl;
	root /usr/share/nginx/html;
	server_name web-server-1.com;
	ssl_certificate /etc/ssl/nginx/web-server-1.crt;
	ssl_certificate_key /etc/ssl/nginx/web-server-1.key;
}
EOF
sudo nginx -s reload
echo

