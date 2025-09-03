variable "name" { type = string }
variable "vpc_id" { type = string }
variable "admin_cidr" { type = string }
variable "internal_cidr" { 
  type    = string 
  default = "10.0.0.0/16" 
}
