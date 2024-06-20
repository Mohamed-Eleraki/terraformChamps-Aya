resource "aws_s3_bucket" "s3_tf_test_bucket" {
  bucket = "bucket-one50001"
  force_destroy = true

  tags = {
    Name        = "aya"
    Environment = "terraformChamps"
  }
}

resource "aws_s3_object" "s3_tf_test_logs_directory" {
  bucket = aws_s3_bucket.s3_tf_test_bucket.bucket
  key    = "logs/" # This creates the directory
}

resource "aws_iam_role" "ec2_s3_full_access" {
  name = "EC2S3FullAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_full_access" {
  role       = aws_iam_role.ec2_s3_full_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2_s3_instance_profile" {
  name = "EC2S3InstanceProfile"
  role = aws_iam_role.ec2_s3_full_access.name
}

resource "aws_instance" "example" { # Please update resouce name
  ami           = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_instance_profile.name
}