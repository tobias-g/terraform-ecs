resource "aws_codedeploy_app" "nodejs" {
  compute_platform = "ECS"
  name             = "${local.prefix}-nodejs"

  tags = {
    Name        = "${local.prefix}-nodejs"
    Description = "ECS example CodeDeploy application for our NodeJS service"
  }
}

resource "aws_codedeploy_deployment_group" "nodejs" {
  app_name               = aws_codedeploy_app.nodejs.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${local.prefix}-nodejs"
  service_role_arn       = var.code_deploy_role

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.main.name
    service_name = aws_ecs_service.nodejs.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.https.arn]
      }

      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }

  tags = {
    Name        = "${local.prefix}-nodejs"
    Description = "ECS example CodeDeploy group for our NodeJS service"
  }
}