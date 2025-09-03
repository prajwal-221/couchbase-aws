variable "name" { type = string }
variable "cidr_block" { type = string }
variable "private_subnets_cidrs" { type = list(string) }
variable "public_subnets_cidrs" { type = list(string) }
variable "azs" { type = list(string) }
