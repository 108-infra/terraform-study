module "vpc" {
  source              = "../modules/vpc"
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                 = var.azs
  private_subnet_cidr = var.private_subnet_cidr
  project_name        = var.project_name
}

module "alb" {
  source              = "../modules/alb"
  name                = var.project_name
  env                 = var.env
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  target_instance_ids = module.ec2.instance_ids
  project_name        = var.project_name
}

module "ec2" {
  source                = "../modules/ec2"
  env                   = var.env
  subnet_id             = module.vpc.subnet_id
  vpc_id                = module.vpc.vpc_id
  alb_security_group_id = module.alb.security_group_id
  project_name          = var.project_name
}
