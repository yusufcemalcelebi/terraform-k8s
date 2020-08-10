variable "aws_region" {
    description = "AWS region"
    type = string
    default = "eu-central-1"
}

variable "instance_type" {
    description = "Instance type for dummy machine"
    type = string
    default = "t2.micro"
}

variable "aws_az_list" {
    description = "Availability zone list for region"
    type = list
    default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}