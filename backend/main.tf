resource "aws_s3_bucket" "tf_backend" {
  bucket = "tnycum-prisma-terraform-state"

  tags = {
    Name = "tnycum-prisma-terraform-state"
  }
}
