module "vpc" {
  source               = "../modules/vpc"
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  azs                  = var.azs
  private_subnet_cidr  = var.private_subnet_cidr
  project_name         = var.project_name
  enable_ecs_endpoints = true
}

module "alb_ecs" {
  source            = "../modules/alb-ecs"
  name              = var.project_name
  env               = var.env
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  project_name      = var.project_name
}

module "ecs" {
  source                = "../modules/ecs"
  env                   = var.env
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.vpc.private_subnet_id
  alb_security_group_id = module.alb_ecs.security_group_id
  target_group_arn      = module.alb_ecs.target_group_arn
  container_image       = "nginx:latest"
  region                = var.region
}

module "ecr" {
  source          = "../modules/ecr"
  repository_name = "${var.project_name}-${var.env}"
  tags = {
    Project = var.project_name
    Env     = var.env
  }
}
