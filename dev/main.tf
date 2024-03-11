module "network" {
  source = "../modules/network"

  region = var.region
}

# module "cluster" {
#   source = "../modules/cluster"

#   ssh_key_name    = var.ssh_key_name
#   ssh_public_key  = var.ssh_public_key
#   ssh_allowed_ips = var.ssh_allowed_ips

#   vpc_id              = module.network.vpc_id
#   public_subnet_id    = module.network.public_subnet_id
#   public_subnet_cidr  = module.network.public_subnet_cidr
#   private_subnet_id   = module.network.private_subnet_id
#   private_subnet_cidr = module.network.private_subnet_cidr
# }
