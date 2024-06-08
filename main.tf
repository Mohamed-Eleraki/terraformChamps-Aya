


    provider "aws" {
  region = "us-east-1"
}

# Variables
variable "environment" {
  default = "terraformChamps"
}

variable "owner" {
  default = "aya"
}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "aya-bucket-01"  
  
  
  
  
  force_destroy = true

  

  
  tags = {
    Environment = "terraformChamps"
    Owner       = "aya"
  }
}

# Create logs/ directory under the S3 Bucket
resource "aws_s3_bucket_object" "logs_directory" {
  bucket = aws_s3_bucket.terraform_state_bucket.bucket
  key    = "logs/"
  acl    = "private"

  tags = {
    Name = "logs/"
  }
}


