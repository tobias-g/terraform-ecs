#!/bin/bash

set -e

readonly APPSPEC_FILENAME="appspec-ecs.yml"
readonly TASK_DEF_FILENAME="task-definition.json"

function print_usage {
  echo
  echo "Usage: ./code-deploy.sh [OPTIONS]"
  echo
  echo "This script performs deployment of ECS Service using AWS CodeDeploy."
  echo
  echo "Required arguments:"
  echo
  echo -e "  --cluster\tName of ECS Cluster"
  echo -e "  --service\tName of ECS Service to update"
  echo -e "  --region\tAWS region to deploy to"
  echo
  echo "Example:"
  echo
  echo "  ./code-deploy.sh --cluster sandbox-ecs --service ecs-nodejs --region eu-west-1"
}

function assert_not_empty {
  local -r arg_name="$1"
  local -r arg_value="$2"

  if [[ -z "$arg_value" ]]; then
    echo "ERROR: The value for '$arg_name' cannot be empty"
    print_usage
    exit 1
  fi
}

function ecs_deploy_service() {
  aws ecs deploy \
    --cluster "$cluster" \
    --service "$service" \
    --region "$region" \
    --task-definition "$TASK_DEF_FILENAME" \
    --codedeploy-appspec "$APPSPEC_FILENAME" \
    --codedeploy-application "sandbox-ecs-nodejs" \
    --codedeploy-deployment-group "sandbox-ecs-nodejs"
}

function ecs_deploy {
  local cluster=""
  local service=""
  local region=""

  while [[ $# -gt 0 ]]; do
    local key="$1"

    case "$key" in
      --cluster)
        cluster="$2"
        shift
        ;;
      --service)
        service="$2"
        shift
        ;;
      --region)
        region="$2"
        shift
        ;;
      --help)
        print_usage
        exit
        ;;
      *)
        echo "ERROR: Unrecognized argument: $key"
        print_usage
        exit 1
        ;;
    esac

    shift
  done

  assert_not_empty "--cluster" "$cluster"
  assert_not_empty "--service" "$service"
  assert_not_empty "--region" "$region"

  echo "Deploy ECS service"
  ecs_deploy_service
  echo "Done!"
}

ecs_deploy "$@"
