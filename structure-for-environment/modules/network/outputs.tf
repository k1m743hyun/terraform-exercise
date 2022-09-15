output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [ for k, sbn in aws_subnet.this : sbn.id if k < 3 ]
}

output "private_subnet_ids" {
  value = [ for k, sbn in aws_subnet.this : sbn.id if k > 2 ]
}