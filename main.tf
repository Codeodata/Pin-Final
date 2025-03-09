# Configuración del Backend para almacenar el estado en S3
terraform {
  backend "s3" {
    bucket  = var.bucket_name   # Nombre del bucket S3
    key     = "terraform.tfstate"                 # Nombre del archivo de estado dentro del bucket
    region  = var.region                         # Región de AWS donde se encuentra el bucket S3
    encrypt = true                              # Activar cifrado para el archivo de estado
    acl     = "bucket-owner-full-control"        # Permite control total al propietario del bucket
  }
}
# Crear la instancia EC2
resource "aws_instance" "monitoring" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  user_data                   = file("metrics.sh")  # Script de inicialización

  tags = {
    Name = var.instance_name
  }
}

# Salida de la dirección IP pública
output "instance_public_ip" {
  value = aws_instance.monitoring.public_ip
}