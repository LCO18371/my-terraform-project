terraform {
  backend "s3" {
    bucket  = "nv-terraform-st-bucket"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "iam_roles" {
  source = "./modules/iam_roles"

  for_each = { for pipeline in var.pipelines : pipeline.app_name => pipeline }

  app_name = each.value.app_name
}


module "codepipeline" {
  source = "./modules/codepipeline"

  for_each = { for pipeline in var.pipelines : pipeline.app_name => pipeline }

  app_name                = each.value.app_name
  cloudformation_role_arn = module.iam_roles[each.key].cloudformation_role_arn
  codepipeline_role_arn   = module.iam_roles[each.key].codepipeline_role_arn
  codebuild_role_arn      = module.iam_roles[each.key].codebuild_role_arn
  aws_region              = var.aws_region
  sam_output_file         = each.value.sam_output_file
  parameters_file         = each.value.parameters_file
  github_repo_branch      = each.value.github_repo_branch
  github_repo_name        = each.value.github_repo_name
  buildspec_file_api      = each.value.buildspec_file_api
}

