resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets_cidrs[count.index]
  availability_zone       = element(var.azs, count.index % length(var.azs))
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets_cidrs[count.index]
  availability_zone       = element(var.azs, count.index % length(var.azs))
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  
  tags = { 
    Name = "${var.name}-igw" 
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  
  tags = {
    Name = "${var.name}-nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.igw]
  
  tags = {
    Name = "${var.name}-nat-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  
  tags = { 
    Name = "${var.name}-public-rt" 
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  
  tags = { 
    Name = "${var.name}-private-rt" 
  }
}

# Public Route (Internet Gateway)
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Private Route (NAT Gateway)
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Public Subnet Route Table Associations
resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Subnet Route Table Associations
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Network Load Balancer
resource "aws_lb" "couchbase_nlb" {
  name               = "${var.name}-couchbase-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.public[*].id

  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.name}-couchbase-nlb"
  }
}

resource "aws_lb_listener" "couchbase_nlb_listener_8091" {
  load_balancer_arn = aws_lb.couchbase_nlb.arn
  port              = 8091
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.couchbase_nlb_tg_8091.arn
  }
}

resource "aws_lb_target_group" "couchbase_nlb_tg_8091" {
  name     = "${var.name}-tg-8091"
  port     = 8091
  protocol = "TCP"
  vpc_id   = aws_vpc.this.id

  stickiness {
    enabled = true
    type    = "source_ip"
  }
  
  health_check {
    protocol = "TCP"
    port     = 8091
  }

  tags = {
    Name = "${var.name}-tg-8091"
  }
}

resource "aws_lb_listener" "couchbase_nlb_listener_11210" {
  load_balancer_arn = aws_lb.couchbase_nlb.arn
  port              = 11210
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.couchbase_nlb_tg_11210.arn
  }

}

resource "aws_lb_target_group" "couchbase_nlb_tg_11210" {
  name     = "${var.name}-tg-11210"
  port     = 11210
  protocol = "TCP"
  vpc_id   = aws_vpc.this.id

  health_check {
    protocol = "TCP"
    port     = 11210
  }
    stickiness {
    enabled = true
    type    = "source_ip"
  }

  tags = {
    Name = "${var.name}-tg-11210"
  }
}

# Attach Couchbase instances to target groups
resource "aws_lb_target_group_attachment" "couchbase_8091_attachments" {
  for_each         = var.instance_ids_map
  target_group_arn = aws_lb_target_group.couchbase_nlb_tg_8091.arn
  target_id        = each.value
  port             = 8091
}

resource "aws_lb_target_group_attachment" "couchbase_11210_attachments" {
  for_each         = var.instance_ids_map
  target_group_arn = aws_lb_target_group.couchbase_nlb_tg_11210.arn
  target_id        = each.value
  port             = 11210
}
