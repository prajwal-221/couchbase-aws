variable "name" { type = string }
variable "cidr_block" { type = string }
variable "private_subnets_cidrs" { type = list(string) }
variable "public_subnets_cidrs" { type = list(string) }
variable "azs" { type = list(string) }

variable "instance_ids" {
  type        = list(string)
  description = "List of Couchbase EC2 instance IDs to attach to the NLB"
  default     = []
}

variable "instance_ids_map" {
  type        = map(string)
  description = "Static-keyed map of instance IDs for NLB attachments"
  default     = {}
}
