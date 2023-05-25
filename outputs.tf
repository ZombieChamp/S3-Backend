output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.this.arn
}

output "s3_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "s3_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "s3_bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "s3_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = aws_s3_bucket.this.region
}

output "dynamodb_table_arn" {
  description = "The ARN of the table."
  value       = try(one(aws_dynamodb_table.this[*].arn), "")
}

output "dynamodb_table_id" {
  description = "The name of the table."
  value       = try(one(aws_dynamodb_table.this[*].id), "")
}

output "dynamodb_table_replica_arns" {
  description = "The ARN(s) of the replica(s)."
  value       = try(one(aws_dynamodb_table.this[*].replica.*.arn), [])
}
