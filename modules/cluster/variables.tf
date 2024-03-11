variable "ssh_key_name" {
  description = "ssh_key_name"
  type        = string
}

variable "ssh_public_key" {
  description = "ssh_public_key"
  type        = string
}

variable "ssh_allowed_ips" {
  description = "ssh_allowed_ips"
  type        = list(any)
  default     = []
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "public_subnet_id" {
  description = "public_subnet_id"
  type        = string
}

variable "public_subnet_cidr" {
  description = "public_subnet_cidr"
  type        = string
}

variable "private_subnet_id" {
  description = "private_subnet_id"
  type        = string
}

variable "private_subnet_cidr" {
  description = "private_subnet_cidr"
  type        = string
}