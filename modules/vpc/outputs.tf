output "vpc_id" {
  description = "The ID of the AWS VPC"
  value       = aws_vpc.this.id
}

output "subnets" {
  value = { for k, sbn in aws_subnet.this : sbn.tags.Name => sbn.id }
}
