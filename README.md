# Couchbase Deployment

This repository contains Terraform and Ansible code to deploy a Couchbase cluster on AWS.

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform (>= 1.0.0)
3. Ansible
4. SSH key pair in AWS

## Directory Structure

```
couchbase-deploy/
├── terraform/               # Terraform configuration
│   ├── environments/        # Environment-specific configs
│   │   └── dev/             # Development environment
│   └── modules/             # Reusable Terraform modules
│       ├── vpc/             # VPC and networking
│       ├── security_group/   # Security group rules
│       └── ec2/             # EC2 instances
└── ansible/                 # Ansible configuration
    ├── playbooks/           # Playbooks for different operations
    └── roles/               # Couchbase role
```

## Usage

### Terraform

1. Navigate to the environment directory:
   ```bash
   cd terraform/environments/dev
   ```

2. Update `terraform.tfvars` with your configuration.

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review the execution plan:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

### Ansible

1. Update the inventory file with your instance IPs:
   ```bash
   cd ../../ansible
   # Update inventory.ini with your instance IPs
   ```

2. Run the playbook to install and configure Couchbase:
   ```bash
   ansible-playbook playbooks/site.yml
   ```

## Variables

### Terraform Variables

- `aws_region`: AWS region (default: us-west-1)
- `admin_cidr`: Your IP address for SSH access
- `key_pair_name`: Name of your AWS key pair
- `create_keypair_from_pub`: Set to true to create a key pair from a public key
- `public_key_path`: Path to your public key file (if creating a key pair)

## Outputs

After applying the Terraform configuration, the following outputs will be available:

- `instance_ids`: List of EC2 instance IDs
- `private_ips`: List of private IPs of the instances
- `public_ips`: List of public IPs of the instances
- `vpc_id`: ID of the created VPC
- `sg_id`: ID of the security group

## Accessing Couchbase Web Console

After deployment, you can access the Couchbase Web Console at:

```
http://<public-ip-of-any-node>:8091
```

Default credentials:
- Username: admin
- Password: password

## Cleanup

To destroy all created resources:

```bash
cd terraform/environments/dev
terraform destroy
```
