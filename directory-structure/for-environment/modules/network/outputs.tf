output "subnet_ids" {
  value = [ for k, sbn in aws_subnet.this : join("-", [k, sbn.id])  ]
}

#output "private_subnet_ids" {
#  value = [ for k, sbn in aws_subnet.this : sbn.id if k > 2 ]
#}