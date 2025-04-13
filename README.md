# 🚀 Proyecto Integrador Final DevOps - 2404

## 👥 Grupo 25

- Agustín Gonzales  
- Santiago Abalos  
- Agustín Correa  

---

## 📈 Implementación de Monitoreo con Grafana y Prometheus en AWS usando Terraform

---

### 🧠 1. Introducción

#### 🎯 Objetivo

Este proyecto demuestra conocimientos avanzados en:

- Automatización de infraestructura con **Terraform**
- Integración y despliegue continuo mediante **GitHub Actions**
- Contenerización de servicios usando **Docker**
- Despliegue en la nube con **AWS** (EC2 + S3)
- Implementación de un stack de **monitoring con Prometheus y Grafana**

Además, se aplicaron buenas prácticas de **seguridad**, **optimización del rendimiento**, y **gestión de infraestructura como código (IaC)**.

Esta guía recorre todo el flujo, desde el aprovisionamiento de infraestructura hasta la visualización de métricas en Grafana.

---

### ☁️ 2. Infraestructura en AWS con Terraform

#### 🔧 Recursos desplegados

- **VPC**: red privada para alojar y segmentar la infraestructura
- **Subnet**: red pública donde corre la instancia EC2
- **Internet Gateway** y **Route Table**: permiten el acceso a Internet
- **Security Group**: reglas de acceso para la EC2
- **Instancia EC2**: donde corren los contenedores Docker
- **S3 Bucket**: almacenamiento remoto del estado de Terraform

#### 📄 Código Terraform (archivo `main.tf`)

- Se define el backend remoto en S3 para compartir el estado entre miembros del equipo.
- Se despliega una instancia EC2 y se le asocia un script de `user_data` para instalar y configurar el stack de monitoreo.


---

### ⚙️ 3. Automatización con GitHub Actions

Se implementaron dos flujos de trabajo para CI/CD con Terraform:

#### ✅ `Terraform Deploy Workflow`

- Descarga del código fuente
- Configuración de AWS CLI
- Inicialización y ejecución de `terraform apply`

#### ❌ `Terraform Destroy Workflow`

- Elimina la infraestructura
- Limpia el estado remoto en S3


---

### 🖥️ 4. Configuración del `user_data` de la EC2

Al lanzar la instancia, se ejecuta automáticamente un script (`metrics.sh`) que:

#### 🐳 A. Instala Docker
- Actualiza el sistema
- Instala Docker y lo habilita al arranque

#### 📊 B. Despliega los servicios de monitoreo con Docker
1. **NGINX + NGINX Exporter**
2. **cAdvisor**: para monitorear contenedores
3. **Prometheus**
4. **Grafana**
5. Configura el archivo `prometheus.yml` dinámicamente

---

### 📡 5. Configuración de Prometheus

- Archivo `prometheus.yml` creado desde `user_data`
- Se agregan targets de:
  - NGINX Exporter
  - cAdvisor

---

### 📊 6. Configuración de Grafana

#### 🔐 Acceso
- **URL**: `http://<PUBLIC_IP>:3000`
- **Usuario/Contraseña por defecto**: `admin / admin`

#### 🔌 Configuración del Data Source
1. Ir a `Configuration > Data Sources`
2. Agregar fuente de datos: **Prometheus**
3. URL: `http://172.18.0.1:9090`
4. Guardar y probar conexión

#### 📈 Creación de Dashboards
1. Ir a `Create > Dashboard`
2. Agregar un panel
3. Elegir métricas desde Prometheus
4. Guardar

---

### ✅ 7. Conclusiones

- La infraestructura se crea de forma automática con **Terraform** y se gestiona con **GitHub Actions**
- Se usó **Docker** para contenerizar todo el stack de monitoreo
- **Prometheus** recolecta métricas y **Grafana** permite visualizarlas de forma clara
- El sistema es reproducible, escalable y fácil de mantener

---
