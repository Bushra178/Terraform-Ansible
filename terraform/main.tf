# run "terraform init" command to install aws provider
provider "aws" {
    region = "ap-south-1"
    access_key = "AKIA5PCN6HLAYSVBKQVT"
    secret_key = "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"
}

#declare variables
variable "subnet_cidr_block" {
  description = "subnet cidr block"
  default = "10.0.10.0/24"
}
variable "vpc_cidr_block" {
  description = "vpc cidr block"
}


#create a new resource
resource "aws_vpc" "development-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name : "tera-development"
        vpc_env : "dev"
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.vpc_cidr_block
    availability_zone = "ap-south-1a"
    tags = {
        Name : "subnet-1-dev"
    }
}

#query an existing resource
data "aws_vpc" "existing_vpc" {
    default = true
}

resource "aws_subnet" "dev-aws_subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.48.0/20"
    availability_zone = "ap-south-1a"
}

#print the attribute you wanna see the values of
output "dev-vpc-id" {
    value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
}


#delete a resource by cmd "terraform destroy -target resource_type.resource_name"
#best practice is to remove code from file and apply changes


