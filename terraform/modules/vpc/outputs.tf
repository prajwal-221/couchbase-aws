output "vpc_id" { 
  value = aws_vpc.this.id 
}

output "private_subnets" { 
  value = aws_subnet.private[*].id 
}

output "public_subnets" { 
  value = aws_subnet.public[*].id 
}

output "azs" {
  value = var.azs
}

output "nat_gateway_id" { 
  value = aws_nat_gateway.nat.id 
}

output "nat_gateway_ip" { 
  value = aws_eip.nat.public_ip 
}

output "nlb_arn" {
  value = aws_lb.couchbase_nlb.arn
}

output "nlb_dns_name" {
  value = aws_lb.couchbase_nlb.dns_name
}

output "nlb_listener_8091_arn" {
  value = aws_lb_listener.couchbase_nlb_listener_8091.arn
}

output "nlb_listener_11210_arn" {
  value = aws_lb_listener.couchbase_nlb_listener_11210.arn
}

output "nlb_tg_8091_arn" {
  value = aws_lb_target_group.couchbase_nlb_tg_8091.arn
}

output "nlb_tg_11210_arn" {
  value = aws_lb_target_group.couchbase_nlb_tg_11210.arn
}
