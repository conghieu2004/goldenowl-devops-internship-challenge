resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  network_mode              = "awsvpc"
  requires_compatibilities  = ["EC2"]
  execution_role_arn        = var.execution_role_arn

  container_definitions = jsonencode([{
    name      = "nodejs-app"
    image     = var.ecr_image_url
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

resource "aws_ecs_service" "app" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "EC2"

  network_configuration {
    subnets = var.private_subnets
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "nodejs-app"
    container_port   = 3000
  }

  depends_on = [var.alb_listener_arn]
}
