variable "app_name" {
  description = "Application name for which IAM roles are created"
  type        = string
}

variable "custom_permissions" {
  description = "Custom IAM permissions for each pipeline"
  type        = map(any) # Accepts different permissions per pipeline
  default     = {}
}
