terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure aws provider
provider "aws" {
  region  = "us-east-1"
  profile = "aya" # force destroy even if the bucket not empty
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "aya"
    Environment = "terraformChamps"
  }
}

resource "aws_s3_object" "logs_directory" {
  bucket = aws_s3_bucket.my-tf-test-bucket.bucket
  key    = "logs/" # This creates the directory
}

resource "aws_iam_user" "Mostafa" {
    name = "Mostafa"
}
resource "aws_iam_user" "Taha" {  
    name = "Taha"
}

# Define the IAM role
resource "aws_iam_role" "taha_role" {
  name = "TahaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::891377122503:user/Taha"
        }
      }
    ]
  })

  tags = {
    Name        = "TahaRole"
    Environment = "terrafomChamps"
  }
}

# Define the policy
resource "aws_iam_policy" "taha_s3_policy" {
  name        = "TahaS3Policy"
  description = "Allow Taha to get objects from logs directory"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Resource = "arn:aws:s3:::terraformChamps/logs/*"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "taha_policy_attachment" {
  role       = aws_iam_role.taha_role.name
  policy_arn = aws_iam_policy.taha_s3_policy.arn
}

# Create S3 bucket policy
resource "aws_s3_bucket_policy" "mostafa_put_policy" {
  bucket = aws_s3_bucket.my-tf-test-bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:PutObject"
        Resource = "arn:aws:s3:::terraformChamps/*"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Mostafa"
        }
      }
    ]
  })
}
