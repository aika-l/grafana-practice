#!/bin/bash

function prep_bastion() {
    sudo apt update
    if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]
    then 
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    fi
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
}

function create_instance() {
    cd terraform 
    terraform init
    terraform apply --auto-approve
}

function remote_backend() {

  cat <<EOF > backend.tf
terraform {
  backend "s3" {
    bucket = "group5-grafana-practice"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
EOF

  yes | terraform init -reconfigure
}



prep_bastion
create_instance
sleep 20
remote_backend


