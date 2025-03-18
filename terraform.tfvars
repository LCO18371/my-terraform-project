# Global Static Variables
CodeBuildImage = "aws/codebuild/standard:7.0"
#github_user    = "LCO18371"
github_token = "12345"
aws_region   = "us-east-1"
#------------------------------------------------------------------------------------------
# Pipelines Configuration (Pipeline-Specific Variables)
pipelines = [
  {
    app_name           = "nvprd-hc-product"
    github_repo_name   = "my-terraform-project"
    github_repo_branch = "main"
    github_user        = "LCO18371"
    parameters_file    = "vitals_sync/prd_parameters.json"
    sam_input_file     = "vitals_sync/saml.yaml"
    sam_output_file    = "post-saml.yaml"
    buildspec_file_api = "vitals_sync/buildspec.yml"
  },
  {
    app_name           = "nvprd-hc-vitals"
    github_repo_name   = "my-terraform-project"
    github_repo_branch = "main"
    github_user        = "LCO18371"
    parameters_file    = "vitals_sync/prd_parameters.json"
    sam_input_file     = "vitals_sync/saml.yaml"
    sam_output_file    = "post-saml.yaml"
    buildspec_file_api = "vitals_sync/buildspec.yml"
  }
]
