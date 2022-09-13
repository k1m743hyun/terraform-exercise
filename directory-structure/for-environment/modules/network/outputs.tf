output "public_subnet_ids" {
  value = [ for k, sbn in aws_subnet : sbn.id if k < 3 ]
}

output "private_subnet_ids" {
  value = [ for k, sbn in aws_subnet : sbn.id if k > 2 ]
}