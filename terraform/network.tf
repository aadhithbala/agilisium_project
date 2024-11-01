# Using the default VPC (Due to freetier) 
data "aws_vpc" "default" {
  default = true
}

#Retrieving the available subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}