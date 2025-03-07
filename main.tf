resource "aws_instance" "monitoring" {
  ami                         = "ami-0866a3c8686eaeeba"  # ID de la AMI
  instance_type               = "t2.micro"               # Tipo de instancia EC2
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.subnet.id
  user_data                   = file("Contenedores.sh")  # Ejecutar el script al lanzar la instancia

  tags = {
    Name = "monitoring"
  }
}