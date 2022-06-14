# Monitoring



## LAB 1: Prometheus



1. Install Prometheus

   ```
   sudo apt install -y prometheus
   systemctl status prometheus
   ```

2. Configure Prometheus

   ```bash
   sudo vi /etc/prometheus/prometheus.yml
   ```

   add the following configuration to the end of the file:

   ```
     - job_name: nginx
       static_configs:
               - targets: ['localhost:9113']
   ```

   > localhost:9113 is where the nginx-prometheus-exporter listens by default

3. Download the nginx-prometheus-exporter:

   ```
   
   nginx-prometheus-exporter -nginx.plus -nginx.scrape-uri=http://<nginx-plus>:8080/api
   
   
   sudo apt install -y prometheus-nginx-exporter
   ```

   

2. stats

   ```
   server {
           listen 8081;
           location /api {
                   api write=on;
           }
           location /dashboard {
                   try_files $uri $uri.html /dashboard.html;
           }
   }
   ```

3. Configure Prometheus

   ```
   sudo vim /etc/default/prometheus-nginx-exporter
   ```

   ```
   ARGS="-nginx.plus -nginx.scrape-uri=http://127.0.0.1:8081/api"
   ```

   ```
   sudo systemctl restart prometheus-nginx-exporter
   sudo systemctl status prometheus-nginx-exporter
   ```

4. Install traffic generator and generate some load:

   ```bash
   sudo apt install -y hey
   
   hey -z 5m http://10.1.1.9/ &
   hey -z 5m https://10.1.1.9/
   ```

5. See the results in Prometheus.

   Use Chrome to visit:

   Then click Graph in the menu and Grpah under the Execute command:

   In the Expression.. field, start typing: `nginxplus_`

   Choose some of those metrics and click Execute.



# LAB 2: Grafana



1. Install Grafana:

   ```
   cd /home/ubuntu
   sudo apt-get install -y adduser libfontconfig1
   wget https://dl.grafana.com/oss/release/grafana_9.0.0_amd64.deb
   sudo dpkg -i grafana_9.0.0_amd64.deb
   ```

   

