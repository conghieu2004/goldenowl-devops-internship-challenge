output "vpc_id" {
  value = module.vpc.vpc_id
}

output "bastion_ip" {
  value = module.bastion.public_ip
}

output "ecr_repo" {
  value = module.ecr.repository_url
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
