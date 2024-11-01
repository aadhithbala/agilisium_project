# Using the default VPC (Due to freetier) 
data "aws_vpc" "default" {
  default = true
}