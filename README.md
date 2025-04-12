# Proyecto integrador final DevOps 2404

## Grupo 25

### Integrantes:

  Agustin Gonzales
  Santiago Abalos
  Agustin Correa


---

## **Implementación de Monitoreo con Grafana y Prometheus en AWS con Terraform**

### **1. Introducción**

#### **Objetivo**
En esta presentación vamos a exponer los conocimientos avanzados sobre la administración y automatización de infraestructura en la nube utilizando **Terraform**, la integración y despliegue continuo con **GitHub Actions**, la gestión eficiente de contenedores con **Docker**, el despliegue y configuración de servicios en **AWS** con instancias **EC2** y almacenamiento en **S3**, y la implementación de herramientas de monitoreo como **Grafana** y **Prometheus** para la recopilación, análisis y visualización de métricas en tiempo real. Además, exploramos buenas prácticas en **seguridad, optimización del rendimiento y gestión de infraestructura como código**.

Esta presentación explica paso a paso el proceso completo, desde la creación de la infraestructura hasta la configuración final de Grafana y Prometheus.

---

## **2. Infraestructura en AWS con Terraform**

### **Componentes Desplegados**
Para esta implementación usamos los siguientes recursos en **AWS**:

- **VPC (Virtual Private Cloud)**: Red privada que aloja la infraestructura y segmenta la comunicación interna.
- **Internet Gateway**: Permite que la instancia EC2 tenga acceso a Internet.
- **Route Table**: Define las reglas de tráfico dentro de la VPC.
- **Subnet**: Red pública dentro de la VPC donde se encuentra la instancia EC2.
- **Security Group**: Define reglas de acceso para permitir conexiones específicas.
- **Instancia EC2**: Servidor virtual donde se ejecutan los contenedores de Docker.
- **S3 Bucket**: Almacena el estado de Terraform de manera segura.

### **Código Terraform**
#### **Archivo `main.tf`**
Define el backend remoto para almacenar el estado de Terraform en **AWS S3** en lugar de localmente.

- `bucket`: Indica el nombre del bucket donde se guardará el archivo de estado.
- `key`: Define el nombre del archivo dentro del bucket (`terraform.tfstate`).
- `region`: Específica la región donde se encuentra el bucket (`us-east-1`).
- `encrypt`: Habilita el cifrado del estado para mayor seguridad.

**Beneficio:** Permite trabajar en equipo y mantener sincronizado el estado de la infraestructura sin conflictos.

#### **Definición de la instancia EC2**
- `ami`: Define la **AMI** (Amazon Machine Image) para lanzar la instancia.
- `instance_type`: Especifica el tipo de instancia EC2 (Ejemplo: `t2.micro` o `t3.medium`).
- `key_name`: Nombre de la clave SSH para acceder a la instancia.
- `associate_public_ip_address = true`: Asigna una IP pública a la instancia.
- `subnet_id = aws_subnet.subnet.id`: Especifica en qué subred dentro de una VPC se va a lanzar la instancia.
- `vpc_security_group_ids = [aws_security_group.sg.id]`: Asigna grupos de seguridad para controlar el tráfico.
- `user_data = file("metrics.sh")`: Ejecuta el script de inicialización (`metrics.sh`), que instala herramientas de monitoreo.
- `tags`: Agrega una etiqueta `"Name"` con el valor de `var.instance_name` para identificar la instancia en AWS.

**Beneficio:** Automatiza la creación de la máquina con un script de configuración desde el arranque.

**Código completo:** [main.tf](https://github.com/diegolavezzari/PIN-GRUPO-4/blob/main/main.tf)

---

## **3. Automatización con GitHub Actions**

La automatización se realiza mediante dos flujos de trabajo:

### **Terraform Deploy Workflow**
- Descarga el código fuente.
- Configura AWS CLI con credenciales.
- Inicializa Terraform.
- Ejecuta `terraform apply` para desplegar la infraestructura.

### **Terraform Destroy Workflow**
- Elimina la infraestructura desplegada.
- Borra los archivos de estado de Terraform en S3.

**Logs de ejecución:** [GitHub Actions Logs](https://github.com/diegolavezzari/PIN-GRUPO-4/actions/workflows/terraform.yml)

---

## **4. Definición de `user_data` de la Instancia EC2**

### **A - Actualización e instalación de Docker**
- Se actualizan los paquetes del sistema.
- Se instala Docker para manejar contenedores.

### **B - Habilitar y arrancar Docker**
- Se inicia el servicio Docker.
- Se configura para que se ejecute automáticamente en cada reinicio de la máquina.

### **C - Configurar y levantar servicios de monitoreo**
1. **Levantar NGINX y NGINX Prometheus Exporter**
2. **Configurar Prometheus (`prometheus.yml`)**
3. **Levantar cAdvisor para monitoreo de contenedores**
4. **Levantar Prometheus y Grafana**

**Código completo:** [metrics.sh](https://github.com/diegolavezzari/PIN-GRUPO-4/blob/main/metrics.sh)

---

## **5. Configuración de Prometheus**

- Creamos archivo `prometheus.yml` desde `user_data`.
- Configuramos fuentes de métricas (NGINX Exporter, cAdvisor).

---

## **6. Configuración de Grafana**

### **Acceso y Configuración**
- **URL:** `http://<PUBLIC_IP>:3000`
- **Usuario:** `admin`
- **Contraseña:** `admin` (se recomienda cambiarla).

### **Configurar Datasource Prometheus en Grafana**
1. Ir a `Configuration > Data Sources`.
2. Agregar **Prometheus**.
3. En **URL**, ingresar: `http://172.18.0.1:9090`.
4. Guardar y Testear.

### **Crear un Dashboard en Grafana**
1. Ir a `Create > Dashboard`.
2. Agregar un nuevo panel.
3. Seleccionar la métrica de **Prometheus**.
4. Guardar el Dashboard.

---

## **7. Conclusión**

- La infraestructura se despliega automáticamente con **Terraform** y **GitHub Actions**.
- **Docker** gestiona los contenedores.
- **Grafana y Prometheus** permiten visualizar métricas y establecer alertas en tiempo real.
- Se implementó un **flujo de trabajo completo** desde la configuración hasta la visualización de datos.

---

## **8. Referencias**

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
