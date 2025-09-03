resource "aws_security_group" "couchbase" {
  name        = var.name
  description = "Security group for Couchbase cluster nodes"
  vpc_id      = var.vpc_id

  # SSH from admin CIDR
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
    description = "SSH from admin"
  }

  # Couchbase inter-node & admin UI ports
  ingress {
    from_port   = 4369
    to_port     = 4369
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
    description = "epmd"
  }
  # Node to node internal communication
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
    self        = true
    description = "internal"
  }
  ingress {
    from_port   = 8091
    to_port     = 8091
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
    description = "Couchbase admin UI"
  }
  
  ingress {
    from_port   = 8092
    to_port     = 8094
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
    description = "Couchbase views/query etc"
  }
  
  ingress {
    from_port   = 11210
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
    description = "Data/memcached ports"
  }
  
  # Optional TLS/SSL and UI HTTPS ports
  ingress {
    from_port   = 18091
    to_port     = 18093
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
    description = "Couchbase HTTPS admin / services"
  }
  
  # Cluster internal (range used by some versions)
  ingress {
    from_port   = 21100
    to_port     = 21299
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
    description = "Couchbase node-to-node range"
  }

  # Allow all egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = var.name }
}

