module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "interview-project-vpc"
  cidr = "10.0.0.0/16"

  # There will be one subnet per AZ and one NAT Gateway per AZ

  azs = ["eu-west-1a", "eu-west-1b"]
  # There will be 2 public subnets for the load balancer
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  # There will be 2 private subnets for the autoscaling application
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  # There will be 2 private subnets for the database
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  single_nat_gateway     = false

  create_database_subnet_group = false

  tags = {
    Terraform = "true"
  }
}
