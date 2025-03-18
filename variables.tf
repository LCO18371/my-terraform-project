variable "app_name" {
  type        = string
  description = "Application name"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}
variable "CodeBuildImage" {
  default = "aws/codebuild/standard:7.0"
}

variable "parameters_file" {
  type        = string
  description = "Path to the parameters file"
}

variable "sam_input_file" {
  type        = string
  description = "Path to the SAM input file"
}

variable "sam_output_file" {
  type        = string
  description = "Path to the SAM output file"
}

variable "buildspec_file_api" {
  type        = string
  description = "Path to the buildspec file for API"
}

variable "github_repo_name" {
  type        = string
  description = "GitHub repository name"
}

variable "github_repo_branch" {
  type        = string
  description = "GitHub repository branch"
}

variable "github_user" {
  type        = string
  description = "GitHub username"
}

variable "github_token" {
  type        = string
  description = "GitHub access token (keep it secure!)"
}
