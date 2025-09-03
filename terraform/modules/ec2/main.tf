# Find the latest Ubuntu 22.04 LTS AMI in the current region
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu) AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Launch Ubuntu instances
resource "aws_instance" "couchbase" {
  count                       = var.instance_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet_ids, count.index % length(var.subnet_ids))
  key_name                    = local.effective_key_name
  associate_public_ip_address = var.assign_public_ip
  vpc_security_group_ids      = var.security_group_ids

  tags = {
    Name = "${var.name}-${count.index + 1}"
    Role = "couchbase-node"
  }
}