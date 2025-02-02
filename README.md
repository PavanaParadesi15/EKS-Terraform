# EKS-Terraform
Creating EKS Cluster on AWS using terraform, creates VPC , SUBNETS 

Welcome to the EKS-Terraform !! 

# Creating EKS cluster through Terraform Scripts

* Create a EC2 instance to install Terraform. 
* Install AWS CLI on this EC2  instance. 
* Provide access keys and secret access keys to authorize with AWS account
* Configure terraform to connect to AWS account . 
* When terraform scripts is executed it creates VPC, withi VPC create EKS Cluster.
* EKS cluster will have auto-scaling which creates EC2 instances based on the mentioned count and scales it based on the incoming traffic. 
* Desired state of the instances inside EKS cluster is 2 , and maximum can scale upto 6 instances
* Creates security groups for the EKS cluster

## Install AWS CLI
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws --version
```
## Install Terraform 

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y
terraform --version
```

## Connect to AWS 
```
aws configure                  // give access key and secrect access key . These creds are stored in the credentials file in the VM
``` 

* We have to connect Terraform with AWS. Terraform will use the aws security credentials (access key and secret key) to connect to AWS
* Breakdown the terraform files according to individual resource we have  to create, instead of just creating main.tf and put everything in one single file. This makes readability difficult and increases complexity to fix the code of a particular resource. 
* Modification for a particular resource would be easy when we create seperate/individual terraform file for each resource.
* Use Modules. any repeatable code can be put into module, which can be shared when needed and reused later on. 
* When we write a particular module, provide a source for that which explains from where the module is taken. 


* When we run " terraform init " commmand, terraform downloads all the modules and the all the modules information is put inside " .terraform "folder.
* All the providers mentioned in "versions.tf" are downloaded by terraform

The resources that will be created with this terraform scripts are:
* VPC , IAM roles, IAM role policies, default security group, node security group , default network ACL , public and private subnets, route table private, default route table, EKS cluster security group, Internet Gateway, route table public , eip-nat (EIP- Elastic IP,  NAT- Network Address Translation) , NAT gateway, route table association, aws-eks managed node group, security group rules, EKS Cluster.

* To create permissions, to view nodes on the eks cluster, we need to create access entry, grant permissions

### Terraform commands 

```
terraform init                // initializes terraform in the project directory
terraform plan                // creates a plan which shows what all the resources are getting created. 
terraform apply               // applies the plan and creates resources
terraform destroy             // destroys all the resources
```




