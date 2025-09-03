aws_region = "us-west-1"
admin_cidr = "0.0.0.0/0"        # replace with your IP/CIDR
key_pair_name = "jenkins-testing"   # or set create_keypair_from_pub = true
create_keypair_from_pub = false
public_key_path = "/home/ht-admin/Downloads/keys-testing/jenkins-testing.pem"                # if create_keypair_from_pub = true, set path to .pub file
