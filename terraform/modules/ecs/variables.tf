variable "environment" {
  type        = string
  description = "Environment we are deploying to either sandbox, staging or prod"
  validation {
    condition     = contains(["sandbox", "staging", "prod"], var.environment)
    error_message = "Environment must be either \"sandbox\", \"staging\" or \"prod\"."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC we're deploying our infrastructure into"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets to deploy our containers to"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets to deploy our loadbalancer to"
}