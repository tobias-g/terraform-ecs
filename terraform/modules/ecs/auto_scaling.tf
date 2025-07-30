# The scaling policy here attempts to keep the ECS tasks CPU values between 10
# to 20%. The step adjustments allow us to increase capacity a small amount or
# larger amount depending on how big the difference in CPU is to our target.
# The way we've implemented this here is we scale up quick (if the CPU spike is
# large) but scale down slow (only ever 1 at a time).

resource "aws_appautoscaling_target" "auto_scaling" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.nodejs.name}"
  role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_scaling" {
  name               = "${aws_ecs_service.nodejs.name}-cpu"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.auto_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.auto_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.auto_scaling.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    # Scale down 1 at a time (slow)
    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }

    # If CPU has only increased by 0-10% of our alarm threshold scale up 1 at a
    # time (slow)
    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 10
      scaling_adjustment          = 1
    }

    # If CPU has increased by 10-20% of our alarm threshold scale up a bit
    # faster (increase by 4)
    step_adjustment {
      metric_interval_lower_bound = 10
      metric_interval_upper_bound = 20
      scaling_adjustment          = 4
    }

    # If CPU has increased by 20% or more of our alarm threshold scale up extra
    # quick (increase by 8)
    step_adjustment {
      metric_interval_lower_bound = 20
      scaling_adjustment          = 8
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_scale_up" {
  alarm_name          = "${aws_ecs_service.nodejs.name}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.nodejs.name
  }

  alarm_description = "Alarm to check if ECS service needs to scale up due to CPU usage"
  alarm_actions     = [aws_appautoscaling_policy.cpu_scaling.arn]

  tags = {
    Name        = "${aws_ecs_service.nodejs.name}-cpu-high"
    Description = "Alarm to check if ECS service needs to scale up due to CPU usage"
  }
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_scale_down" {
  alarm_name          = "${aws_ecs_service.nodejs.name}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.nodejs.name
  }

  alarm_description = "Alarm to check if ECS service needs to scale down due to CPU usage"
  alarm_actions     = [aws_appautoscaling_policy.cpu_scaling.arn]

  tags = {
    Name        = "${aws_ecs_service.nodejs.name}-cpu-low"
    Description = "Alarm to check if ECS service needs to scale down due to CPU usage"
  }
}
