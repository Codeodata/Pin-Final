provider "aws" {
  region = var.region  # Usando la variable de región
}

# Configuración del Backend para almacenar el estado en S3
terraform {
  backend "s3" {
    bucket = var.bucket_name   # Usando la variable para el bucket
    key    = "terraform.tfstate"
    region = var.region
    encrypt = true
    acl     = "terraform-state"
  }
}