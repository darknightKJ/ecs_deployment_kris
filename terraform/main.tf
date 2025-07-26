locals {
  prefix = "kael-dev"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "kael_vpc" {
  tags = {
    Name = var.vpc_name
  }

}

data "aws_subnets" "kael_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.kael_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*public*"] # Matches names like "kael-vpc-public-ap-southeast-1a"
  }
}

resource "aws_ecr_repository" "ecr" {
  name = "${local.prefix}-ecr"
  force_delete =  true
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.9.0"

  cluster_name = "${local.prefix}-ecs"
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    kael-TASKDEFINITION = { #task definition and service name -> #Change
      cpu    = 512
      memory = 1024
      container_definitions = {
        kael-ECS-CONTAINER = { #container name -> Change
          essential = true
          image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.id}.amazonaws.com/${local.prefix}-ecr:latest"
          port_mappings = [
            {
              containerPort = 8080
              protocol      = "tcp"
            }
          ]
        }
      }
      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                   = flatten(data.aws_subnets.kael_public.ids) #List of subnet IDs to use for your tasks
      security_group_ids           = [module.ecs_sg.security_group_id] #Create a SG resource and pass it here
    }
  }
}

module "ecs_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  name = "${local.prefix}-ecs-sg"
  description = "Security group for ecs"
  vpc_id = data.aws_vpc.kael_vpc.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["http-8080-tcp"]
  egress_rules = ["all-all"]

}