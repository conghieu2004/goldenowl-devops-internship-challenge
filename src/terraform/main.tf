module "vpc" {
  source          = "./modules/vpc"
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "bastion" {
  source         = "./modules/bastion"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  key_name       = var.key_name
  ami_id         = var.ami_id
  project_name   = var.project_name
}

module "ecr" {
  source        = "./modules/ecr"
  project_name  = var.project_name
}

module "iam" {
  source        = "./modules/iam"
  project_name  = var.project_name
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  project_name   = var.project_name
}

module "route53" {
  count              = var.domain_name != "" ? 1 : 0
  source             = "./modules/route53"
  domain_name        = var.domain_name
  subdomain          = var.subdomain
  alb_dns_name       = module.alb.alb_dns_name
  alb_zone_id        = module.alb.alb_zone_id
  create_certificate = var.enable_ssl
  project_name       = var.project_name
}

module "ecs" {
  source                = "./modules/ecs"
  private_subnets       = module.vpc.private_subnets
  ecr_image_url         = module.ecr.repository_url
  execution_role_arn    = module.iam.ecs_task_execution_role_arn
  target_group_arn      = module.alb.target_group_arn
  alb_listener_arn      = module.alb.alb_listener_arn
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  alb_security_group_id = module.alb.alb_security_group_id
}
