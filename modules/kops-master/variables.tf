variable "subnet" {
    description = "Subnet used by kops instance"
    type = string
}

variable "security_group" {
    description = "Security group used by kops instance"
    type = string
}

variable "vpc" {
    description = "Existed VPC for k8s cluster"
    type = string
}

variable "iam_policy_arn" {
    description = "Required policies for kops master"
    default = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess",
     "arn:aws:iam::aws:policy/AmazonS3FullAccess",
     "arn:aws:iam::aws:policy/IAMFullAccess",
     "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
     "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"]
     type = list
}