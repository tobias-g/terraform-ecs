variable "environment" {
  type        = string
  description = "Environment we are deploying to either sandbox, staging or prod"
  validation {
    condition     = contains(["sandbox", "staging", "prod"], var.environment)
    error_message = "Environment must be either \"sandbox\", \"staging\" or \"prod\"."
  }
}

variable "cidr" {
  type        = string
  description = "CIDR range for our VPC"
  default     = "10.0.0.0/21"
}