resource "aws_ecs_cluster" "cluster" {
    name = var.cluster_name
}

resource "aws_ecs_task_definition" "node_app_task_definition" {
    family = var.ecs_family_name
    container_definitions = templatefile("templates/${var.environment}/ecs-task-definition.json.tpl",
    {
        task_name = "${var.ecs_task_definition_name}-${var.environment}"
        image     = aws_ecr_repository.node_app_ecr.repository_url
    }
    )
    requires_compatibilities = [
        "FARGATE"
    ]
    network_mode             = "awsvpc"    
    memory                   = 512      
    cpu                      = 256
    execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name        = "${var.name}-ecs-exec"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
        type        = "Service"
        identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
    role       = aws_iam_role.ecsTaskExecutionRole.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_default_vpc" "default_vpc" {
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "us-east-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "us-east-1b"
}

resource "aws_ecs_service" "node_app_service" {
    name            = var.ecs_service_name
    cluster         = aws_ecs_cluster.cluster.id
    task_definition = aws_ecs_task_definition.node_app_task_definition.arn
    launch_type     = "FARGATE"
    desired_count   = var.desired_count

    load_balancer {
        target_group_arn = aws_lb_target_group.target_group.arn
        container_name   = "${var.ecs_task_definition_name}-${var.environment}"
        container_port   = 3000
    }

    network_configuration {
        subnets = [ aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id ]
        assign_public_ip = true
        security_groups  = [aws_security_group.service_security_group.id]
    }
}
