output "couchbase_instance_ids" { 
  value = module.ec2_couchbase.instance_ids 
}

output "couchbase_private_ips" { 
  value = module.ec2_couchbase.private_ips 
}

output "bastion_instance_id" { 
  value = module.ec2_bastion.instance_ids[0] 
}

output "bastion_public_ip" { 
  value = module.ec2_bastion.public_ips[0] 
}

output "bastion_private_ip" { 
  value = module.ec2_bastion.private_ips[0] 
}

output "sg_couchbase_id" { 
  value = module.sg_couchbase.sg_id 
}

output "sg_bastion_id" { 
  value = module.sg_bastion.sg_id 
}

output "vpc_id" { 
  value = module.vpc.vpc_id 
}

output "nat_gateway_ip" {
  value = module.vpc.nat_gateway_ip
}

output "nlb_dns_name" {
  value = module.vpc.nlb_dns_name
}

output "nlb_arn" {
  value = module.vpc.nlb_arn
}
