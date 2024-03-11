terraform {
  backend "s3" {
    bucket = "tnycum-prisma-terraform-state"
    key = "state/terraform.tfstate"
    region = "us-west-2"
  }
}
