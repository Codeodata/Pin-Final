resource "aws_instance" "monitoring" {
  ami                         = var.ami_id  # ID de la AMI
  instance_type               = var.instance_type               # Tipo de instancia EC2
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.subnet.id
  user_data                   = file("metrics.sh")  # Ejecutar el script al lanzar la instancia

  tags = {
    Name = var.instance_name
  }
}
