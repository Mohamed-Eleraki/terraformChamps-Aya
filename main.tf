provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  type    = string
  default = "terraform-workshop-aya"
}

variable "environment" {
  type    = string
  default = "terraformChamps"
}

variable "owner" {
  type    = string
  default = "aya"
}

terraform {
  backend "s3" {
    bucket = "erakiterrafromstatefiles"
    key    = "project1/statefiles/statefile.tfstate"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "terraformbucket" {
  bucket = var.bucket_name

  tags = {
    "Environment" = var.environment
    "Owner"       = var.owner
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.terraformbucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraformbucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraformbucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.terraformbucket.id

  rule {
    id     = "expire object after 7 days"
    status = "Enabled"

    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.terraformbucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}



    
