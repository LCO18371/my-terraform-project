module "iam_roles" {
  source   = "./modules/iam_roles"
  app_name = var.app_name
}

module "codepipeline" {
  source                  = "./modules/codepipeline"
  app_name                = var.app_name
  cloudformation_role_arn = module.iam_roles.cloudformation_role_arn
  codepipeline_role_arn   = module.iam_roles.codepipeline_role_arn # FIXED

  codebuild_role_arn = module.iam_roles.codebuild_role_arn
  aws_region         = var.aws_region
  sam_output_file    = var.sam_output_file
  parameters_file    = var.parameters_file
  github_repo_branch = var.github_repo_branch
  github_repo_name   = var.github_repo_name
  buildspec_file_api = var.buildspec_file_api
}
