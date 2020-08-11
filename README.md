# Terraform with AWS
Includes terraform modules to create *k8s* infrastructure on *AWS*.


-  [aws-networking-setup module](modules/aws-networking-setup/main.tf)
  - Includes networking resources that requires for k8s setup with **kops** 
  - VPC, internet gateway, route tables, private and public subnets, security group with configured ports for kops-master instance

- [kops-master module](modules/kops-master/main.tf)
  - Includes aws **ec2** instance resource to create **kops-master** workload to run kops commands 
  - **[IAM role](modules/kops-master/iam-role.tf)** to provide access required AWS resources for kops cli
  - Network interface and public ip address for the instance
  - s3 bucket to store kops state
  - Includes configurations to run on created kops-master instance
    -  [install-plugins.sh](modules/kops-master/configurations/install-plugins.sh) : install binaries required for kops (kubectl, kops, awscli)
    -  [create-cluster.sh](modules/kops-master/configurations/create-cluster.sh)  : kops commands to create k8s cluster

