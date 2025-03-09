terraform {
  backend "s3" {
    bucket  = var.bucket_name   # Nombre del bucket S3
    key     = "terraform.tfstate"                 # Nombre del archivo de estado dentro del bucket
    region  = var.region                         # Región de AWS donde se encuentra el bucket S3
    encrypt = true                              # Activar cifrado para el archivo de estado
    acl     = "bucket-owner-full-control"        # Permite control total al propietario del bucket
  }
}
resource "aws_instance" "monitoring" {
  ami                         = var.ami_id  # ID de la AMI
  instance_type               = var.instance_type               # Tipo de instancia EC2
  key_name                    = "Miclaveprivada"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.subnet.id
  user_data                   = file("metrics.sh")  # Ejecutar el script al lanzar la instancia

  tags = {
    Name = var.instance_name
  }
}