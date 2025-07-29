# We'll grab the latest task definition instead of creating it in Terraform.
# This is because we'll create & update the task definition in our "app" folder
# and deploy it from there too. This is essentially the line between what is an
# app deploy and what is an infrastructure deploy.
data "aws_ecs_task_definition" "nodejs" {
  task_definition = "ecs-nodejs"
}
