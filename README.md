
## Table of Contents:
- [Prerequisites](#prerequisites)
- [How to run the program](#how-to-run-the-program)
- [Creating custom VPC](#creating-custom-vpc)
- [Creating security group](#creating-security-group)
- [Creating variables](#creating-variables)
- [Remote backend](#remote-backend)
- [Creating EC2 instance with AMI image](#creating-ec2-instance-with-ami-image)
- [Installing Prometheus Grafana and Node Exporter](#installing-prometheus-grafana-and-node-exporter)


### Prerequisites
- [x] Have EC2 instance - Ubunutu 22.04 (host) started in AWS.
- [x] Have IAM User with Terraform permissions 
- [x] Create S3 bucket manually on AWS Console for backend, use versioning. Inside the file **backend.tf** replace values for a ***bucketname*** and ***region***  
- [x] Create file: **terraform.tfvars** inside ***Terraform*** folder with the following and replace values per your need:
```
region = "us-east-2"  
vpc_cidr = "10.0.0.0/16" 
subnet1_cidr = "10.0.1.0/24"
subnet2_cidr = "10.0.2.0/24"
subnet3_cidr = "10.0.3.0/24"
ip_on_launch = true
instance_type = "t2.micro"
```

### How to run the program
The starting point for our application to perform all the tasks automatically is inside the **script.sh** file. Which needs to be started once you have all the prereqs ready.
  - Function prep_bastion() will update Ubuntu VM and install Terraform on that VM.
  - Function create_instance() will go into Terraform folder that above function created. It will initialize Terraform and applies Terraform.

### Creating custom VPC
 The file: **vpc.tf** defines custom VPC, subnets, internet gateway, route table, and route table associations.

### Creating security group
File **sg.tf** configures the security group and opens ports:
   - 9090 : for Prometheus
   - 3000 : for Grafana
   - 22   : for SSH  
   - 9100 : for Node Exporter
  
### Creating variables
File **variables.tf** contains variables for our code reusability and flexibility

### Remote backend
Terraform will initialize backend on remote backend using S3 bucket that was created as a prerequisite which is described in **backend.tf** file. It also have ***use_locking*** set to true, so it can use lockfile for locking the state file.

### Creating EC2 instance with AMI image
Defined EC2 instance with AMI image in **ec2.tf** file that can be created in any region. Also defined the aws_key_pair to control login access to EC2 instance. Lastly it uses **user_data** to run a script that installs Prometheus, Grafana and Node Exporter during initial launch of EC2.

### Installing Prometheus Grafana and Node Exporter
During creation of EC2 instance that happens in ec2.tf file, it will also installs the Prometheus, Grafana, and Node Exporter.

* It will create Prometheus user first using sudo privileges
* Downloads and extracts the file using wget and URL, and then using TAR it will unpack the archive file
*  Sets the directories for which file should be where
* Sets the ownership
* Creates the prometheus system service
* Enables and starts the prometheus service
---
* The same way it will create a user for Node Exporter  
* Download and extract the file from web
* Move the binaries
* Configure the node exporter as system service
* Enable and start node expoerter service
* Update prometheus.yml file to have node_exporter job 
---
* Install Grafana
* Enable and start Grafana service


#### Team members and estimated time of work done by each member:
* Aika: 20hrs
* Rada: 14hrs
* Muna: 10hrs
* Kairat:5hrs