resource "aws_key_pair" "tnycum" {
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
}

resource "aws_security_group" "bastion" {
  name        = "tnycum-bastion"
  description = "Allow SSH inbound"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = var.ssh_allowed_ips
    description = "Allow ssh from desktop"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = var.ssh_allowed_ips
    description = "Allow ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
  }

  egress {
    description = "allow all output"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  }

  tags = {
    Name = "tnycum-bastion"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.tnycum.key_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "tnycum-bastion"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id

  tags = {
    Name = "tnycum-bastion-eip"
  }
}

resource "aws_security_group" "cluster" {
  name        = "tnycum-cluster"
  description = "Allow SSH inbound"
  vpc_id      = var.vpc_id

  ingress {
    security_groups = [aws_security_group.bastion.id]
    cidr_blocks     = [var.private_subnet_cidr]
    description     = "Allow ssh from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
  }

  ingress {
    security_groups = [aws_security_group.bastion.id]
    cidr_blocks     = [var.private_subnet_cidr]
    description     = "Allow ping"
    from_port       = 0
    to_port         = 0
    protocol        = "ICMP"
  }

  egress {
    description = "allow all output"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  }

  tags = {
    Name = "tnycum-cluster"
  }
}

resource "aws_security_group" "master" {
  name        = "tnycum-master"
  description = "Allow access to kubernetes api port"
  vpc_id      = var.vpc_id

  ingress {
    security_groups = [aws_security_group.cluster.id]
    description     = "Allow ssh from bastion"
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
  }
  tags = {
    Name = "tnycum-master"
  }
}

resource "aws_instance" "master" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.large"
  key_name               = aws_key_pair.tnycum.key_name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.cluster.id, aws_security_group.master.id]

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "tnycum-master"
  }
}

resource "aws_instance" "node" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.large"
  key_name               = aws_key_pair.tnycum.key_name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.cluster.id]

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "tnycum-node"
  }
}