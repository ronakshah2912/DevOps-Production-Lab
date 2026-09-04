locals {
  name_prefix = "${var.project_name}-${var.environment}"

  tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      managed_by  = "Terraform"
    }
  )
}

data "aws_iam_policy_document" "ec2_assume_role" {

  statement {
    sid     = "AllowEC2AssumeRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_instance_role" {
  name               = "${local.name_prefix}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = merge(local.tags, { Name = "${local.name_prefix}-ec2-instance-role" })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${local.name_prefix}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    sid     = "AllowLambdaAssumeRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "${local.name_prefix}-lambda-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags               = merge(local.tags, { Name = "${local.name_prefix}-lambda-execution-role" })
}

data "aws_iam_policy_document" "s3_readonly" {
  statement {
    sid       = "AllowListConfiguredBuckets"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = var.s3_readonly_bucket_arns
  }

  statement {
    sid       = "AllowReadObjectsFromConfiguredBuckets"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = [for bucket_arn in var.s3_readonly_bucket_arns : "${bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "s3_readonly_policy" {
  count       = length(var.s3_readonly_bucket_arns) > 0 ? 1 : 0
  name        = "${local.name_prefix}-s3-readonly-policy"
  description = "Least-privilege read-only access to configured S3 buckets."
  policy      = data.aws_iam_policy_document.s3_readonly.json
  tags        = merge(local.tags, { Name = "${local.name_prefix}-s3-readonly-policy" })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_readonly" {
  count      = length(var.s3_readonly_bucket_arns) > 0 ? 1 : 0
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.s3_readonly_policy[0].arn
}

data "aws_iam_policy_document" "cloudwatch_logging" {
  statement {
    sid       = "AllowCreateLogGroups"
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["*"]
  }
  statement {
    sid       = "AllowWriteApplicationLogs"
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams"]
    resources = var.cloudwatch_log_group_arns
  }
}

resource "aws_iam_policy" "cloudwatch_logging_policy" {
  # count = length(var.cloudwatch_log_group_arns) > 0 ? 1 : 0
  name        = "${local.name_prefix}-cloudwatch-logging-policy"
  description = "Least-privilege CloudWatch logging policy"
  policy      = data.aws_iam_policy_document.cloudwatch_logging.json
  tags        = merge(local.tags, { Name = "${local.name_prefix}-cloudwatch-logging-policy" })
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_logging" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.cloudwatch_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_logging" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logging_policy.arn
}

data "aws_iam_policy_document" "least_privilege_lambda_s3_read" {
  statement {
    sid       = "AllowLambdaReadSpecificS3Objects"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = [for bucket_arn in var.s3_readonly_bucket_arns : "${bucket_arn}/lambda-input/*"]
  }
}

resource "aws_iam_policy" "lambda_least_privilege_s3_policy" {
  count       = length(var.s3_readonly_bucket_arns) > 0 ? 1 : 0
  name        = "${local.name_prefix}-lambda-least-privilege-s3-policy"
  description = "Example least-privilege Lambda policy for reading only lambda-input prefix."
  policy      = data.aws_iam_policy_document.least_privilege_lambda_s3_read.json
  tags        = merge(local.tags, { Name = "${local.name_prefix}-lambda-least-privilege-s3-policy" })
}

resource "aws_iam_role_policy_attachment" "lambda_least_privilege_s3" {
  count      = length(var.s3_readonly_bucket_arns) > 0 ? 1 : 0
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_least_privilege_s3_policy[0].arn
}