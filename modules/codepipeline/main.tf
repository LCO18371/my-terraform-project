resource "aws_codebuild_project" "terraform_plan_build" {
  name         = "terraform-plan-${var.app_name}"
  description  = "CodeBuild project for running terraform plan"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = var.CodeBuildImage
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"  # Run only terraform plan
  }
}

resource "aws_codebuild_project" "terraform_apply_build" {
  name         = "terraform-apply-${var.app_name}"
  description  = "CodeBuild project for running terraform apply"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = var.CodeBuildImage
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec_apply.yml"  # Run only terraform apply
  }
}

resource "aws_codepipeline" "project_pipeline" {
  name     = "${var.app_name}-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = "nv-tf-artifacts-bucket"
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      configuration = {
        ConnectionArn        = "arn:aws:codeconnections:us-east-1:008893372207:connection/3a79559b-dda5-4bc4-bc67-3bc0a3acd502"
        BranchName           = var.github_repo_branch
        FullRepositoryId     = var.github_repo_name
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Terraform-Plan"
    action {
      name             = "TerraformPlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["PlanArtifact"]  # This stores the Terraform plan output
      configuration = {
        ProjectName = aws_codebuild_project.terraform_plan_build.name
      }
    }
  }

  stage {
    name = "ManualApproval"
    action {
      name     = "ManualApproval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Terraform-Apply"
    action {
      name             = "TerraformApply"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["PlanArtifact"]  # Takes the output of Terraform plan
      configuration = {
        ProjectName = aws_codebuild_project.terraform_apply_build.name
      }
    }
  }
}
