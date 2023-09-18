# run "terraform init" command to install aws provider
provider "aws" {
    region = "ap-south-1"
    access_key = "AKIA5PCN6HLAYSVBKQVT"
    secret_key = "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"
}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name : "${var.env_prefix}-vpc"
    }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "myapp-server" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.myapp-vpc.id
  image_name = var.image_name
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  my_ip = var.my_ip
  instance_type = var.instance_type
  subnet_id = module.myapp-subnet.subnet.id
  ssh-key-private = var.ssh-key-private
}






#terraform does not encourage to use provisioners, one issue is that of timing, our ansible playbook 
#will run before the ec2 is initialized and started,  
# resource "aws_route_table_association" "a-rtb-subnet" {
#     subnet_id = aws_subnet.myapp-subnet-1.id
#     route_table_id = aws_route_table.myapp-route-table.id
# }

# #print the attribute you wanna see the values of
# output "dev-vpc-id" {
#     value = aws_vpc.development-vpc.id
# }

# output "dev-subnet-id" {
#     value = aws_subnet.dev-subnet-1.id
# }

# resource "aws_route_table" "myapp-route-table" {
#     vpc_id = aws_vpc.myapp-vpc.id

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.myapp-igw.id
#     }

#     tags = {
#         Name : "${var.env_prefix}-rtb"
#     }
# }


#delete a resource by cmd "terraform destroy -target resource_type.resource_name"
#best practice is to remove code from file and apply changes


