variable "name" { 
  type        = string 
  description = "Name of the security group"
}

variable "vpc_id" { 
  type        = string 
  description = "ID of the VPC where the security group will be created"
}

variable "admin_cidr" { 
  type        = string 
  description = "CIDR block for admin access"
}

variable "internal_cidr" {
  type        = string 
  default     = "10.0.0.0/16"
  description = "CIDR block for internal VPC communication"
}

variable "is_bastion" {
  type        = bool
  default     = false
  description = "Whether this security group is for a bastion host"
}
