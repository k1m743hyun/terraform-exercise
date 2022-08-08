output "private_subnet_ids" {
  value = [ for k, sbn in aws_subnet.private : sbn.id ]
}