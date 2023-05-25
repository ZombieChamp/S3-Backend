
resource "aws_s3_bucket" "this" {
  bucket = var.s3_bucket["name"]

  tags = {
    Name = var.s3_bucket["name"]
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.s3_bucket["versioning"] ? 1 : 0

  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "this" {
  count = var.s3_bucket["logging_bucket_id"] == null ? 0 : 1

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.s3_bucket["logging_bucket_id"]
  target_prefix = "${aws_s3_bucket.this.id}/"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.deny_unsecure_communications.json
}

data "aws_iam_policy_document" "deny_unsecure_communications" {
  statement {
    sid    = "DenyUnsecureCommunications"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# Used to validate var.dynamodb_table["replica_regions"] region entries
data "aws_region" "this" {
  for_each = toset(var.dynamodb_table["replica_regions"])

  name = each.key
}

resource "aws_dynamodb_table" "this" {
  count = var.dynamodb_table["name"] == null ? 0 : 1

  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = true
  hash_key                    = "LockID"
  name                        = var.dynamodb_table["name"]

  tags = {
    Name = var.dynamodb_table["name"]
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  dynamic "point_in_time_recovery" {
    for_each = var.dynamodb_table["point_in_time_recovery"] ? [1] : []

    content {
      enabled = var.dynamodb_table["point_in_time_recovery"]
    }
  }

  dynamic "replica" {
    for_each = toset(var.dynamodb_table["replica_regions"])

    content {
      region_name = replica.key
    }
  }
}
