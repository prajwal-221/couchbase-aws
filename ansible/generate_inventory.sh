#!/bin/bash
set -e

TERRAFORM_DIR="/home/ht-admin/projects/avis/couchbase/prajwal-couchbase/prajwal/Couchbase/couchbase-deploy/couchbase-aws/terraform/environments/dev"

cd "$TERRAFORM_DIR"

BASTION_PUBLIC_IP=$(terraform output -raw bastion_public_ip)
COUCHBASE_PRIVATE_IPS=($(terraform output -json couchbase_private_ips | jq -r '.[]'))

# Resolve SSH key path (defaulting to the correct user home). Allow override via SSH_KEY_PATH env var.
: "${SSH_KEY_PATH:=/home/ht-admin/Downloads/keys-testing/jenkins-testing.pem}"

cd - > /dev/null

cat > inventory.ini << EOF
[bastion]
bastion-host ansible_host=${BASTION_PUBLIC_IP} ansible_user=ubuntu

[couchbase_nodes]
EOF

for i in "${!COUCHBASE_PRIVATE_IPS[@]}"; do
    node_num=$((i + 1))
    echo "couchbase-node-${node_num} ansible_host=${COUCHBASE_PRIVATE_IPS[i]} ansible_user=ubuntu private_ip=${COUCHBASE_PRIVATE_IPS[i]}" >> inventory.ini
done

cat >> inventory.ini << EOF

[couchbase_nodes:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -i ${SSH_KEY_PATH} -W %h:%p -o StrictHostKeyChecking=no ubuntu@${BASTION_PUBLIC_IP}" -o StrictHostKeyChecking=no'
EOF

echo "Inventory generated with working SSH configuration!"
