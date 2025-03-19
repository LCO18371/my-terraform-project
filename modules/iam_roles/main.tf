
resource "aws_iam_role" "codebuild_role" {
  name = "${var.app_name}-codebuild-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "codebuild.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "CodeBuildRolePolicy"
  description = "IAM policy for AWS CodeBuild service role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    { "Effect": "Allow", "Action": "*", "Resource": "*" },
    { "Effect": "Allow", "Action": "s3:*", "Resource": "*" },
    { "Effect": "Allow", "Action": ["kms:GenerateDataKey*", "kms:Encrypt", "kms:Decrypt"], "Resource": "*" },
    { "Effect": "Allow", "Action": "sns:SendMessage", "Resource": "*" }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "codebuild_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_iam_role" "cloudformation_role" {
  name = "${var.app_name}-cloudformation-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "cloudformation.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "cloudformation_policy" {
  name        = "CloudFormationRolePolicy"
  description = "IAM policy for AWS CloudFormation service role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    { "Effect": "Allow", "Action": "*", "Resource": "*" },
    { "Effect": "Allow", "Action": "s3:PutObject", "Resource": "arn:aws:s3:::codepipeline*" },
    { "Effect": "Allow", "Action": "lambda:*", "Resource": "arn:aws:lambda:*:*:function:*" },
    { "Effect": "Allow", "Action": "apigateway:*", "Resource": "arn:aws:apigateway:*::*" },
    { "Effect": "Allow", "Action": ["iam:GetRole", "iam:CreateRole", "iam:DeleteRole"], "Resource": "arn:aws:iam::*:role/${var.app_name}-*" },
    { "Effect": "Allow", "Action": ["iam:AttachRolePolicy", "iam:DetachRolePolicy"], "Resource": "arn:aws:iam::*:role/${var.app_name}-*" },
    { "Effect": "Allow", "Action": "iam:PassRole", "Resource": "*" },
    { "Effect": "Allow", "Action": "cloudformation:CreateChangeSet", "Resource": "arn:aws:cloudformation:*:aws:transform/Serverless-2016-10-31" }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cloudformation_attach" {
  role       = aws_iam_role.cloudformation_role.name
  policy_arn = aws_iam_policy.cloudformation_policy.arn
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.app_name}-codepipeline-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "codepipeline.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "codepipeline_policy" {
  name        = "CodePipelineRolePolicy"
  description = "IAM policy for AWS CodePipeline service role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    { "Effect": "Allow", "Action": "*", "Resource": "*" },
    { "Effect": "Allow", "Action": "s3:PutObject", "Resource": "arn:aws:s3:::codepipeline*" },
    { "Effect": "Allow", "Action": ["codebuild:StartBuild", "codebuild:BatchGetBuilds"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["cloudwatch:*", "s3:*", "sns:*", "cloudformation:*", "rds:*", "sqs:*", "iam:PassRole"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["lambda:InvokeFunction", "lambda:ListFunctions"], "Resource": "*" }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}
