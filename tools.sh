#!/bin/bash
# Script de User Data para ejecutar al lanzar la instancia

# Actualizar paquetes
sudo apt-get update -y

# Instalar Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update -y
sudo apt install -y docker-ce

# Habilitar Docker para que inicie con el sistema
sudo systemctl enable docker
sudo systemctl start docker

# Agregar el usuario actual al grupo Docker para evitar el uso de 'sudo' al ejecutar Docker
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl restart docker

# Crear red Docker 'monitoring'
sudo docker network inspect monitoring >/dev/null 2>&1 || \
sudo docker network create monitoring

# Eliminar contenedores existentes (si los hubiera) para evitar conflictos
sudo docker stop prometheus grafana nginx_exporter cadvisor nginx >/dev/null 2>&1
sudo docker rm prometheus grafana nginx_exporter cadvisor nginx >/dev/null 2>&1

# Crear volúmenes persistentes
sudo docker volume create prometheus_data
sudo docker volume create grafana_data
sudo docker volume create nginx_data

# Crear archivo prometheus.yml en /home/ubuntu
cat <<EOF > /home/ubuntu/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'nginx'
    static_configs:
      - targets: ['nginx_exporter:9113']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
EOF

# Crear archivo de configuración de NGINX con stub_status
cat <<EOF > /home/ubuntu/nginx.conf
events {}

http {
  server {
    listen 80;

    location /stub_status {
      stub_status;
      allow all;
    }

    location / {
      root /usr/share/nginx/html;
      index index.html;
    }
  }
}
EOF

# Ejecutar NGINX
sudo docker run -d --restart always --name nginx --network monitoring \
  -v nginx_data:/usr/share/nginx/html:ro \
  -v /home/ubuntu/nginx.conf:/etc/nginx/nginx.conf:ro \
  -p 80:80 nginx

# Esperar unos segundos a que NGINX arranque
until sudo docker exec nginx curl -s http://localhost/stub_status; do
  echo "Esperando que NGINX levante stub_status..."
  sleep 15
done

# Ejecutar NGINX Exporter apuntando a la IP del contenedor nginx

sudo docker stop nginx_exporter
sudo docker rm nginx_exporter
sudo docker run -d --restart always --name nginx_exporter --network monitoring \
  -p 9113:9113 \
  nginx/nginx-prometheus-exporter:latest \
  --nginx.scrape-uri=http://nginx/stub_status

# Ejecutar Grafana
sudo docker run -d --restart always --name grafana --network monitoring \
  -p 3000:3000 \
  -v grafana_data:/var/lib/grafana \
  grafana/grafana

# Ejecutar Prometheus
sudo docker run -d --restart always --name prometheus --network monitoring \
  -p 9090:9090 \
  -v prometheus_data:/prometheus \
  -v /home/ubuntu/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus

sudo docker restart prometheus

# Ejecutar cAdvisor
sudo docker run -d --restart always --name cadvisor --network monitoring \
  -p 8080:8080 \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /sys:/sys:ro \
  -v /var/lib/docker/:/var/lib/docker:ro \
  gcr.io/cadvisor/cadvisor:latest
