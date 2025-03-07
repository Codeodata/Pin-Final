provider "aws" {
  region = var.region  # Usando la variable de región
}

# Configuración del Backend para almacenar el estado en S3
terraform {
  backend "s3" {
    bucket = "terraform-state"  # Nombre fijo del bucket
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    acl     = "bucket-owner-full-control"
  }
}