variable "aws_region" {}
variable "app_name" {}
variable "codepipeline_role_arn" {
}
variable "cloudformation_role_arn" {
  
}
variable "sam_output_file" {
  
}
variable "parameters_file" {
  
}
variable "github_repo_branch" {
  
}
variable "github_repo_name" {
  
}
variable "CodeBuildImage" {
    type = string
    description = "Image used for CodeBuild project."
    default = "aws/codebuild/standard:7.0" 
}
variable "buildspec_file_api" {
  type        = string
  description = "Path to the buildspec file for API"
}
variable "codebuild_role_arn" {
  
}