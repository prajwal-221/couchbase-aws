variable "aws_region" { 
  type    = string 
  default = "us-west-1" 
}

variable "admin_cidr" { 
  type        = string 
  description = "IP/cidr for SSH admin access (e.g. 203.0.113.4/32)" 
}

variable "key_pair_name" { 
  type        = string 
  description = "Existing AWS KeyPair name to attach to instances" 
}

variable "create_keypair_from_pub" { 
  type    = bool 
  default = false 
}

variable "public_key_path" { 
  type    = string 
  default = "/home/ht-admin/Downloads/keys-testing/jenkins-testing.pem" 
}
