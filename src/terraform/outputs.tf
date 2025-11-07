output "vpc_id" {
  value = module.vpc.vpc_id
}

output "bastion_ip" {
  value = module.bastion.public_ip
}

# ECR Outputs
output "ecr_repo_url" {
  value = module.ecr.repository_url
}

output "ecr_repo_name" {
  value = module.ecr.repository_name
}

# ALB Outputs  
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_name" {
  value = module.alb.alb_name
}

output "target_group_name" {
  value = module.alb.target_group_name
}

# ECS Outputs
output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "ecs_task_definition_family" {
  value = module.ecs.task_definition_family
}

# IAM Outputs
output "ecs_execution_role_arn" {
  value = module.iam.ecs_task_execution_role_arn
}

output "ecs_execution_role_name" {
  value = module.iam.ecs_task_execution_role_name
}
