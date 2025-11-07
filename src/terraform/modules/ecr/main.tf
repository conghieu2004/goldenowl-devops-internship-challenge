resource "aws_ecr_repository" "this" {
  name = "${var.project_name}-repo"
  image_scanning_configuration { scan_on_push = true }
  tags = { Name = "${var.project_name}-repo" }
}
