# AWS Region
aws_region = "us-east-1"

# Application Name
app_name = "nvprd-hc-vitals"

# GitHub Repository Details
github_repo_name   = "my-terraform-project"
github_repo_branch = "main"
github_user        = "LCO18371"

# GitHub Token (Ensure this is securely managed)
github_token = "12345"

# CodePipeline Configuration
parameters_file = "vitals_sync/prd_parameters.json"
sam_input_file = "vitals_sync/saml.yaml"
sam_output_file = "post-saml.yaml"
buildspec_file_api = "vitals_sync/buildspec.yml"

# Add missing variables
#codepipeline_template_url = "https://s3.amazonaws.com/my-bucket/codepipeline-template.yml"
#roles_template_url        = "https://s3.amazonaws.com/my-bucket/roles-template.yml"
