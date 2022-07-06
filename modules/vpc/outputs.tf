output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "subnets" {
  value = { for k, sbn in aws_subnet.this : sbn.tags.Name => sbn.id }
}
