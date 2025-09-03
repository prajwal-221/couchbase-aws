output "instance_ids" {
  value = aws_instance.couchbase[*].id
}

output "private_ips" {
  value = aws_instance.couchbase[*].private_ip
}

output "public_ips" {
  value = aws_instance.couchbase[*].public_ip
}
