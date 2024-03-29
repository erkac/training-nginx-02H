# LAB 1: NGINX/NGINX+ and dynamic modules Installation

Learning Objectives:

- Install NGINX open source

- Install NGINX plus

- Interact with NGINX configuration files

- Install dynamic modules

  

> Estimated time: 30min



##  1.1 NGINX Open source - Installing a Prebuilt Debian Package from an OS Repository

1. Go to *OSS_Web_Server* and select *SSH* from Access menu.

2. After login, update the Debian repository information:

    ```bash
    sudo apt-get update
    ```

3. Install the NGINX Open Source package:

   ```bash
   sudo apt-get -y install nginx
   ```

4. Verify the installation:

   ```bash
   sudo nginx -v
   ```

   Example output:

   `nginx version: nginx/1.18.0(ubuntu)`

5. Start NGINX Open Source:

   >  Ignore the error messages if the nginx is already running.

   ```bash
   sudo nginx
   ```

6. Verify that NGINX Open Source is up and running:

   ```bash
   curl -I 127.0.0.1
   ```

   Example output:

   ```
   HTTP/1.1 200 OK
   Server: nginx/1.18.0 (Ubuntu)
   Date: Mon, 13 Jun 2022 07:47:57 GMT
   Content-Type: text/html
   Content-Length: 612
   Last-Modified: Mon, 13 Jun 2022 07:45:28 GMT
   Connection: keep-alive
   ETag: "62a6eb18-264"
   Accept-Ranges: bytes
   ```

   Run:

   ```bash
   curl 127.0.0.1
   ```

   If NGINX is correctly installed you'll get a "*Welcome to NGINX*" page.

  

## 1.2 Execute Basic NGINX Commands

1. Check the running NGINX version:

   ```bash
   nginx -v
   ```

2. Test Configuration file:

   ```bash
   sudo nginx -t
   ```

3. Reload nginx configuration -> needed after any change to nginx config:

   ```bash
   sudo nginx -s reload
   ```

4. Show all the nginx configuration:

   ```bash
   sudo nginx -T
   ```

5. Review nginx configuration file:

   ```bash
   cat /etc/nginx/nginx.conf
   ```

   

## 1.3 NGINX Plus - Installing a Prebuilt Debian Package from an OS Repository

> For our lab, the certificate and key are already in Web_Server_1. Otherwise you need to get the NGINX+ trial license from the F5 Sales team.

1. Go to *Web_Server_1* and select *SSH* from Access menu.

2. Check NGINX repo cert and key are in **/home/ubuntu** and validity of the certificate:

   ```bash
   cd /home/ubuntu
   $ pwd
   /home/ubuntu
   $ ls
   nginx-repo.crt  nginx-repo.key
   ```

   ```bash
   openssl x509 -in nginx-repo.crt -text -noout
   ```

  The nginx repo crtificate should be still valid:
   ```
   ...
   Validity
            Not Before: Mar 17 10:40:03 2023 GMT
            Not After : Sep 13 10:40:03 2023 GMT
   ...
   ```
If the certificate is not valid, please follow the guidance in the UDF Lab Documentation tab.

3. Create the **/etc/ssl/nginx** directory:

   ```bash
   sudo mkdir /etc/ssl/nginx
   ```

4. Copy the files to the **/etc/ssl/nginx/** directory:

   ```bash
   cd /home/ubuntu
   sudo cp nginx-repo.crt /etc/ssl/nginx/
   sudo cp nginx-repo.key /etc/ssl/nginx/
   cd /etc/ssl/nginx
   ls
   ```

5. Download and add [NGINX signing key](https://nginx.org/keys/nginx_signing.key):

   ```bash
   cd /home/ubuntu
   sudo wget https://cs.nginx.com/static/keys/nginx_signing.key \
     && sudo apt-key add nginx_signing.key
   ```

6. Install the prerequisites packages:

   ```bash
   sudo apt-get -y install apt-transport-https lsb-release ca-certificates
   ```

7. Add the NGINX Plus repository:

   ```bash
   printf "deb https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" \
     | sudo tee /etc/apt/sources.list.d/nginx-plus.list
   ```

8. Download the **nginx-plus** apt configuration to **/etc/apt/apt.conf.d**:

   ```bash
   sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
   ```

9. Update the repository information:

   ```bash
   sudo apt-get update
   ```

10. Install the **nginx-plus** package. Any older NGINX Plus package is automatically replaced:

    ```bash
    sudo apt-get install -y nginx-plus
    ```

11. Check the `nginx` binary version to ensure that you have NGINX Plus installed correctly:

    ```bash
    nginx -v
    ```

    Example output:

    `nginx version: nginx/1.21.5 (nginx-plus-r26)`

12. Start NGINX Plus:

    ```bash
    sudo systemctl start nginx
    ```

13. Verify NGINX Plus is running:

    ```bash
    sudo systemctl status nginx
    ```

    Example output:

    `Active: active (running) since Mon 2022-06-13 08:15:02 UTC; 32s ago`

    Press <kbd>q</kbd> to exit, in case the output is long.

14. RDP to windows jump host.

    - Username: **user**
    - Password: **user**

    Open google chrome and go to the following url: http://web-server-1.com

    > If you get “*Welcome to nginx!*” then nginx plus web server is up and running!

<img src="./img/01_lab/nginx-plus-web-server-1.com.png" alt="nginx-plus-web-server-1.com" style="zoom:50%;" />



## 1.4 Installing dynamic modules

NGINX Plus functionality can be extended with dynamically loadable modules that are not included in the prebuilt packages:

- NGINX-authored dynamic modules – Modules written and maintained by **F5, Inc.** Install these modules directly from the official repository:
  - [GeoIP](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/geoip/)
  - [Image-Filter](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/image-filter/)
  - [njs Scripting Language](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/)
  - [Perl](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/perl/)
  - [XSLT](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/xslt/)

- NGINX-certified community dynamic modules – Popular third‑party modules that NGINX tests and distributes, and for which NGINX provides installation and basic configuration support. Install these modules directly from the official repository:

  - [Brotli](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/brotli/)

  - [Cookie-Flag](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/cookie-flag/)

  -  [Encrypted-Session](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/encrypted-session/)

  -  [FIPS Status Check](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/fips/)

  -  [GeoIP2](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/geoip2/)

  -  [Headers-More](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/headers-more/)

  -  [HTTP Substitutions Filter](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/http-substitutions-filter/)

  -  [Lua](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/lua/)

  -  [NGINX ModSecurity WAF](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginx-waf/)

  -  [NGINX Developer Kit](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/ndk/)

  -  [OpenTracing](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/opentracing/)

  -  [Phusion Passenger](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/passenger-open-source/)

  -  [Prometheus-njs](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/prometheus-njs/)

  -  [RTMP](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/rtmp/)

  -  [Set-Misc](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/set-misc/)

  -  [SPNEGO](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/spnego/)

- Community dynamic modules – Modules written and distributed by third‑party members of the NGINX community. Download the source code from the author’s repository and [compile it against the NGINX Open Source version](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/#install_modules_oss) corresponding to your NGINX Plus version. For a list, see the [NGINX Wiki](https://www.nginx.com/resources/wiki/modules/index.html).

 

1. Install **geoip2** dynamic module in nginx plus. Go to *Web_Server_1*:

   ```bash
   sudo apt-get install nginx-plus-module-geoip2
   ```

2. Open nginx.conf file:

   ```bash
   sudo vi /etc/nginx/nginx.conf
   ```

3. Add the below two lines in the **main context** to enable **geoip2** dynamic module.

   ```nginx
   load_module modules/ngx_http_geoip2_module.so;
   load_module modules/ngx_stream_geoip2_module.so;
   ```

4. Press <kbd>Esc</kbd> and <kbd>:wq</kbd>, then check and reload nginx configuration:

   ```bash
   sudo nginx -t && nginx -s reload
   ```

   Example output:

   ```
   nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
   nginx: configuration file /etc/nginx/nginx.conf test is successful
   ```

   You can safely ignore those errors:

   ````
   nginx: [alert] could not open error log file: open() "/var/log/nginx/error.log" failed (13: Permission denied)
   ...
   ````

5. Check installed dynamic modules:

   ```bash
   cd /etc/nginx/modules
   ls
   ```

   Example output:

   ```bash
   ubuntu@ip-10-1-1-10:/etc/nginx/modules$ ls
   ngx_http_geoip2_module-debug.so  ngx_http_geoip2_module.so  ngx_stream_geoip2_module-debug.so  ngx_stream_geoip2_module.so
   ubuntu@ip-10-1-1-10:/etc/nginx/modules$
   ```



 # LAB 2: Reverse Proxy & Web Server configuration 

Learning Objectives:

By the end of the lab you will be able to:

- Configure NGINX as a web server
- Configure NGINX as a reverse proxy
- Configure SSL traffic processing

 

## 2.1 Web Server Setup

1. Access *Web_Server_1* using *SSH*.

2. Create an html page as **app1.html**:

   ```
   sudo vi /usr/share/nginx/html/app1.html
   ```

3. Add the below html code to the file:

   ```html
   <!DOCTYPE html>
   <html>
   <body>
   <h1 style="background-color:DodgerBlue;">This is App1</h1>
   </body>
   </html>
   ```

4. Save and exist.

5. Create an html page as **app2.html**:

   ```bash
   sudo vi /usr/share/nginx/html/app2.html
   ```

6. Add the below html code to the file:

   ```html
   <!DOCTYPE html>
   <html>
   <body>
   <h1 style="background-color:Green;">This is App2</h1>
   </body>
   </html>
   ```

7. Save and exist.

8. Rename the default configuration file:

   ```bash
   sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
   ```

9. Create a new configuration file called **web_server.conf**:

   ```bash
   sudo vi /etc/nginx/conf.d/web_server.conf
   ```

10. Paste the following into the file:

    ```nginx
    server {
    	listen 10.1.1.10:80;
    	server_name web-server-1.com;
    	root /usr/share/nginx/html;
    
    	#For logging
    	access_log /var/log/nginx/map.access.log combined;
    	error_log /var/log/nginx/map.error.log error;
    }
    ```

11. Save and exit the file. 

12. Reload nginx configuration:

    ```bash
    sudo nginx -s reload
    ```

13. Go to *Chrome* in *Windows Jump* box and use the below url:

    ```
    http://web-server-1.com
    ```

    *You should get the nginx default page*

14. Add location directive to **web_server.conf** file into `server {}` part:

    ```bash
    sudo vi /etc/nginx/conf.d/web_server.conf
    ```

    Then paste the following:

    ```nginx
    location = /app1.html {
    	root /usr/share/nginx/html;
    }
    location = /app2.html {
     root /usr/share/nginx/html;
    }
    ```

    The `web_server.conf` file should look like the below:

    ```nginx
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
    ```

15. Save the configuration and exit and then reload nginx configuration:

    ```bash
    sudo nginx -s reload
    ```

16. Now test access to the added new location. Go to *Chrome* in *Windows jump* host and access the following URLS:

    ```
    http://web-server-1.com/app1.html
    
    http://web-server-1.com/app2.html
    ```

    *You should get the below pages:*

    ![01_lab_app1-app2](./img/01_lab/app1-app2.png)

 

## 2.2 Reverse Proxy Configuration

1. Backup the web_server.conf file:

   ```bash
   sudo mv /etc/nginx/conf.d/web_server.conf /etc/nginx/conf.d/web_server.conf.bak
   ```

2. Create **rev_proxy.conf** file:

   ```bash
   sudo vi /etc/nginx/conf.d/rev_proxy.conf
   ```

3. Add the below configuration:

   ```nginx
   server {
   	listen 80;
   	location /1 {
   		proxy_pass http://localhost:8080;
   	}
   
   	location /2 {
   		proxy_pass http://localhost:8081;
   	}
   }
   ```

4. Save, exit the configuration. 

5. Create the following configuration file **app1.conf**:

   ```bash
   sudo vi /etc/nginx/conf.d/app1.conf
   ```

6. Add the below configs:

   ```nginx
   server {
   	listen 8080;
   	location / {
   		return 200 "I am listening on port 8080\n";
   	}
   }
   ```

7. Save, exit the configuration. 

8. Create the following configuration file **app2.conf**:

   ```bash
   sudo vi /etc/nginx/conf.d/app2.conf
   ```

9. Add the below configs:

   ```nginx
   server {
   	listen 8081;
   	location / {
   		return 200 "I am listening on port 8081\n";
   	}
   }
   ```

10. Save, exit the configuration. 

11. Reload nginx configuration:

    ```bash
    sudo nginx -s reload
    ```

12. Go to windows jump server and run `cmd`

13. Test the below URLs to see the behavior change using the `proxy_pass` directive:

    `C:\user\user> curl web-server-1.com/1`

    You should get the message:

    `I am listening on port 8080`

    For URL2 use:

    `C:\user\user> curl web-server-1.com/2`

    You should get the message:

    `I am listening on port 8081`

 

## 2.3 SSL Traffic Processing

1. Use `openssl` to generate a self-signed certificate and key.

   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
     -keyout /etc/ssl/nginx/web-server-1.key \
     -out /etc/ssl/nginx/web-server-1.crt
   ```

2. Enter the values requested by `openssl` for the certificate:

   For **FQDN** enter `web-server-1.com`

3. Open **ssl_test.conf**:

    ```bash
    sudo vi /etc/nginx/conf.d/ssl_test.conf
    ```

4. Add a server context with listen **443** directive. Also add the ssl certificate and key locations you created earlier:

   ```nginx
   server {
   	listen 443 ssl;
   	root /usr/share/nginx/html;
   	server_name web-server-1.com;
   	ssl_certificate /etc/ssl/nginx/web-server-1.crt;
   	ssl_certificate_key /etc/ssl/nginx/web-server-1.key;
   }
   ```

5. Save & exit. Reload nginx config:

   ```bash
   sudo nginx -s reload
   ```

6. Go to chrome and go to the below URL:

   `https://web-server-1.com`

   *You should get the default NGINX page as follows:*
   
   ![https-nginx-plus-web-server-1.com](./img/01_lab/https-nginx-plus-web-server-1.com.png)
   
   



This concludes the Beginner Lab.
