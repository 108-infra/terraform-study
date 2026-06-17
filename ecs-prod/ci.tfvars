env                 = "ecs-prod"
region              = "ap-northeast-1"
vpc_cidr            = "10.3.0.0/16"
public_subnet_cidrs = ["10.3.1.0/24", "10.3.3.0/24"]
private_subnet_cidr = "10.3.2.0/24"
azs                 = ["ap-northeast-1a", "ap-northeast-1c"]
project_name        = "terraform-study"
aws_profile         = ""
