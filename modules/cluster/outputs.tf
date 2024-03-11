output "bastion_ip" {
  value = aws_eip.bastion.public_ip
}

output "master_ip" {
  value = aws_instance.master.private_ip
}
output "node_ip" {
  value = aws_instance.node.private_ip
}