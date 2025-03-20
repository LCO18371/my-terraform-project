
pipelines = [
  {
    app_name           = "nvprd-hc-product-ravi"
    github_repo_name   = "my-terraform-project"
    github_repo_branch = "main"
    github_user        = "LCO18371"
    parameters_file    = "vitals_sync/prd_parameters.json"
    sam_input_file     = "vitals_sync/saml.yaml"
    sam_output_file    = "post-saml.yaml"
    buildspec_file_api = "vitals_sync/buildspec.yml"
  }
  # ,
  # {
  #   app_name           = "nvprd-hc-vitals"
  #   github_repo_name   = "my-terraform-project"
  #   github_repo_branch = "main"
  #   github_user        = "LCO18371"
  #   parameters_file    = "vitals_sync/prd_parameters.json"
  #   sam_input_file     = "vitals_sync/saml.yaml"
  #   sam_output_file    = "post-saml.yaml"
  #   buildspec_file_api = "vitals_sync/buildspec.yml"
  # }
]
