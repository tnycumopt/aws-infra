resource "aws_s3_bucket" "tf_backend" {
  bucket = "tnycum-prisma-terraform-state"

  tags = {
    Name = "tnycum-prisma-terraform-state"
  }
}


resource "aws_s3_bucket_versioning" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id

  versioning_configuration {
    status = "Enabled"
  }
}