provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "terraform-testing" {
  name = "SalmanDevOps"
  tags = {
    Description = "FOr terrform local testing peurpose"
  }
}

resource "aws_iam_policy" "testing-aws_iam_policy" {
  name = "testing-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "testing-policy-attachment" {
  user = aws_iam_user.terraform-testing.name

  policy_arn = aws_iam_policy.testing-aws_iam_policy.arn
}

resource "aws_s3_bucket" "kodekloud" {
  bucket = "kodekloud-25092025"
  tags = {
    Description="Learing and certification"
  }
}

resource "aws_s3_object" "kodekloud" {
  bucket = aws_s3_bucket.kodekloud.id
  key    = "/tesing/iam.tf"
  source = "./iam.tf"
  etag = filemd5("./iam.tf")
}