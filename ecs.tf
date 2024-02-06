provider "aws" {
  region = "us-east-1"  # Change this to your desired AWS region
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task-family"
  container_definitions   = <<DEFINITION
[
  {
    "name": "my-container",
    "image": "nginx:latest",
    "cpu": 256,
    "memory": 512,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "my_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 200

  network_configuration {
    subnets          = ["subnet-12345678"]  # Change this to your subnet IDs
    security_groups  = ["sg-12345678"]     # Change this to your security group IDs
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-target-group/1234567890123456"  # Change this to your target group ARN
    container_name   = "my-container"
    container_port   = 80
  }
}
