#!/bin/bash

set -e  # Exit on error
set -u  # Exit on undefined variables

KEY_NAME="Minecraft_Key"  # Set your key pair name here

echo "🚀 Starting Terraform deployment for EC2 instance..."
cd terraform_dir
terraform init
terraform apply -auto-approve -var="key_pair_name=$KEY_NAME"

echo "🌐 Retrieving instance public IP..."
IP=$(terraform output -raw instance_ip)
cd ..

echo "📝 Generating Ansible inventory file..."
cat > ansible_dir/inventory.ini <<EOF
[minecraft]
$IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/${KEY_NAME}.pem
EOF

echo "⏳ Waiting for SSH access (timeout: 90s)..."

# Wait for port 22 to be open (timeout after 90 seconds)
for i in {1..30}; do
  if nc -z -w1 "$IP" 22; then
    echo "🔓 SSH connection established!"
    break
  fi
  echo "⏱ Attempt $i/30: Waiting for SSH on $IP..."
  sleep 3
done

echo "⚙️  Executing Ansible playbook..."
cd ansible
ansible-playbook -i inventory.ini playbook.yml

echo "🎉 Deployment complete! Minecraft server address: $IP:25565"