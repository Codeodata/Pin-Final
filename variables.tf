variable "bucket_name" {
  description = "Región de AWS donde se encuentra el bucket S3"
  type        = string
  default     = "pin-grupo-25"
}

variable "region" {
  description = "Región de AWS donde se encuentra el bucket S3"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block para la subred"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Zona de disponibilidad para la subnet"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "ID de la AMI a utilizar para la instancia"
  type        = string
  default     = "ami-0866a3c8686eaeeba"
}

variable "security_group_name" {
  description = "Nombre del Security Group"
  type        = string
  default     = "monitoring-sg"
}

variable "instance_name" {
  description = "Nombre de la instancia EC2"
  type        = string
  default     = "monitoring"
}

variable "key_name" {
  description = "Nombre de la instancia EC2"
  type        = string
  default     = "pin-key"
}
