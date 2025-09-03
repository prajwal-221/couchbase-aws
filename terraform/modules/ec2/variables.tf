variable "name" { type = string }

variable "instance_count" { 
  type    = number 
  default = 3 
}

variable "instance_type" { 
  type    = string 
  default = "t3.medium" 
}

variable "subnet_ids" { 
  type = list(string) 
}

variable "key_pair_name" { 
  type = string 
}

variable "security_group_ids" { 
  type = list(string) 
}

variable "assign_public_ip" { 
  type    = bool 
  default = false 
}
