variable "environment" {
  type        = string
  description = "Environment we are deploying to either sandbox, staging or prod"
  validation {
    condition     = contains(["sandbox", "staging", "prod"], var.environment)
    error_message = "Environment must be either \"sandbox\", \"staging\" or \"prod\"."
  }
}
