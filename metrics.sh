#!/bin/bash
# Script de User Data para ejecutar al lanzar la instancia

# Actualizar paquetes
sudo apt-get update -y

# Instalar Docker
sudo apt-get install -y docker.io

# Iniciar y habilitar Docker
sudo systemctl start docker
sudo systemctl enable docker

# Crear red Docker 'monitoring' si no existe
if ! docker network inspect monitoring >/dev/null 2>&1; then
  # Si la red no existe, la crea
  docker network create monitoring
fi

# Eliminar contenedores existentes para evitar conflictos
for container in prometheus grafana nginx_exporter cadvisor nginx; do
  if docker ps -a --format '{{.Names}}' | grep -q "$container"; then
    # Si el contenedor existe, lo elimina
    docker stop $container
    docker rm $container
  fi
done

# Crear volúmenes persistentes si no existen
for volume in prometheus_data grafana_data nginx_data; do
  if ! docker volume ls --format '{{.Name}}' | grep -q "$volume"; then
    # Si el volumen no existe, lo crea
    docker volume create $volume
  fi
done

# Ejecutar NGINX
docker run -d --name nginx --network monitoring \
  -v nginx_data:/usr/share/nginx/html:ro \
  -p 80:80 nginx

# Ejecutar NGINX Exporter
docker run -d --name nginx_exporter --network monitoring \
  --link nginx -p 9113:9113 \
  nginx/nginx-prometheus-exporter:latest \
  -nginx.scrape-uri=http://nginx:80/stub_status

# Crear archivo prometheus.yml en /home/ubuntu (directorio por defecto)
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

# Ejecutar cAdvisor para monitorear contenedores
docker run -d --name cadvisor --network m