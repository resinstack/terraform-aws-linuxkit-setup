data "aws_iam_policy_document" "staging_bucket" {
  statement {
    sid     = "Deny Insecure Access"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "staging" {
  bucket = var.bucket_name
  policy = data.aws_iam_policy_document.staging_bucket.json
}

resource "aws_s3_bucket" "staging_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "staging_bucket" {
  bucket = aws_s3_bucket.staging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
