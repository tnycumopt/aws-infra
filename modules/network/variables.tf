variable "region" {
  description = "region"
  type        = string
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
  default     = "tnycum-vpc"
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_name" {
  description = "public subnet name"
  type        = string
  default     = "10.0.1.0/24 - tnycum-public"
}

variable "public_subnet_cidr" {
  description = "public_subnet_cidr"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_az" {
  description = "public_subnet_az"
  type        = string
  default     = "a"
}

variable "private_subnet_name" {
  description = "private subnet name"
  type        = string
  default     = "10.0.2.0/24 - tnycum-private"
}

variable "private_subnet_cidr" {
  description = "private_subnet_cidr"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_az" {
  description = "private_subnet_az"
  type        = string
  default     = "b"
}

variable "igw_name" {
  description = "igw_name"
  type        = string
  default     = "tnycum-igw"
}