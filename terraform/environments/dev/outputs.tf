output "instance_ids" { 
  value = module.ec2.instance_ids 
}

output "private_ips" { 
  value = module.ec2.private_ips 
}

output "public_ips" { 
  value = module.ec2.public_ips 
}

output "sg_id" { 
  value = module.sg.sg_id 
}

output "vpc_id" { 
  value = module.vpc.vpc_id 
}
