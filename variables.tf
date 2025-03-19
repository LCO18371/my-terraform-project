variable "CodeBuildImage" {
  default     = "aws/codebuild/standard:7.0"
  description = "CodeBuild Image for all pipelines"
}

variable "github_user" {
  default     = "Ravi"
  description = "GitHub username for all pipelines"
}

variable "github_token" {
  default     = "12345"
  description = "GitHub token for authentication"
}

variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region for deployment"
}

variable "pipelines" {
  type = list(object({
    app_name           = string
    github_repo_name   = string
    github_repo_branch = string
    buildspec_file_api = string
    parameters_file    = string
    sam_input_file     = string
    sam_output_file    = string
     # ✅ Ensure this is included
  }))
  description = "List of pipelines to be created dynamically"
}
