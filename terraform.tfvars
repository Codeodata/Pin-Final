vpc_cidr           = "10.0.0.0/16"
subnet_cidr        = "10.0.1.0/24"
availability_zone  = "us-east-1a"
ami_id             = "ami-0866a3c8686eaeeba"  # Ejemplo: Amazon Linux 2 AMI
instance_type      = "t2.micro"
key_name           = "pin-key"  # Nombre de la clave SSH cargada en AWS
instance_name      = "mi-instancia-monitoring" 
