resource "aws_codebuild_project" "build" {
  name         = "codebuild-${var.app_name}"
  description  = "CodeBuild project for ${var.app_name}"
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
    buildspec = var.buildspec_file_api
  }
}

resource "aws_codepipeline" "project_pipeline" {
  name     = "${var.app_name}-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = "nv-tf-artifacts-bucket"  # Use existing bucket name
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
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Deploy"
    
    # Action Group 1: Create ChangeSet
    action {
      name            = "CreateChangeSet"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      version         = "1"
      input_artifacts = ["BuildArtifact", "SourceArtifact"]
      configuration = {
        StackName           = "${var.app_name}-serverless-stack"
        ActionMode          = "CHANGE_SET_REPLACE"
        RoleArn             = var.cloudformation_role_arn
        ChangeSetName       = "pipeline-changeset"
        Capabilities        = "CAPABILITY_IAM,CAPABILITY_AUTO_EXPAND,CAPABILITY_NAMED_IAM"
        TemplatePath        = "BuildArtifact::${var.sam_output_file}"
        TemplateConfiguration = "SourceArtifact::${var.parameters_file}"
      }
    }

    # Action Group 2: Manual Approval
    action {
      name       = "ManualApproval"
      category   = "Approval"
      owner      = "AWS"
      provider   = "Manual"
      version    = "1"
    }

    # Action Group 3: Execute ChangeSet
    action {
      name            = "ExecuteChangeSet"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      version         = "1"
      input_artifacts = ["BuildArtifact", "SourceArtifact"]
      configuration = {
        StackName     = "${var.app_name}-serverless-stack"
        ActionMode    = "CHANGE_SET_EXECUTE"
        RoleArn       = var.cloudformation_role_arn
        ChangeSetName = "pipeline-changeset"
      }
    }
  }

  # Other pipeline stages can go here...
}

  # stage {
  #   name = "Deploy-CreateChangeSet"
  #   action {
  #     name            = "CreateChangeSet"
  #     category        = "Deploy"
  #     owner           = "AWS"
  #     provider        = "CloudFormation"
  #     version         = "1"
  #     input_artifacts = ["BuildArtifact", "SourceArtifact"]
  #     configuration = {
  #       StackName           = "${var.app_name}-serverless-stack"
  #       ActionMode          = "CHANGE_SET_REPLACE"
  #       RoleArn             = aws_iam_role.cloudformation_role.arn
  #       ChangeSetName       = "pipeline-changeset"
  #       Capabilities        = "CAPABILITY_IAM,CAPABILITY_AUTO_EXPAND,CAPABILITY_NAMED_IAM"
  #       TemplatePath        = "BuildArtifact::${var.SAMOutputFile}"
  #       TemplateConfiguration = "SourceArtifact::${var.ParametersFile}"
  #     }
  #   }
  # }

  # stage {
  #   name = "Approval"
  #   action {
  #     name       = "ManualApproval"
  #     category   = "Approval"
  #     owner      = "AWS"
  #     provider   = "Manual"
  #     version    = "1"
  #   }
  # }

  # stage {
  #   name = "Deploy-ExecuteChangeSet"
  #   action {
  #     name            = "ExecuteChangeSet"
  #     category        = "Deploy"
  #     owner           = "AWS"
  #     provider        = "CloudFormation"
  #     version         = "1"
  #     input_artifacts = ["BuildArtifact", "SourceArtifact"]
  #     configuration = {
  #       StackName     = "${var.app_name}-serverless-stack"
  #       ActionMode    = "CHANGE_SET_EXECUTE"
  #       RoleArn       = aws_iam_role.cloudformation_role.arn
  #       ChangeSetName = "pipeline-changeset"
  #     }
  #   }
  # }

