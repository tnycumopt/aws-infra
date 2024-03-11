variable "region" {
  description = "region"
  type        = string
}

variable "environment" {
  description = "Environment e.g. dev/test/prod"
  type        = string
}

variable "owner" {
  description = "Username"
  type        = string
  default     = "Taylor Nycum"
}

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
  type        = list(string)
  default     = []
}