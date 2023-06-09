# AWS S3 Backend Terraform module

Terraform module which creates S3 bucket and (optional) DynamoDB table on AWS with all reccomended security features (that are free) enabled by default (with costing features optional).

The following features of the S3 bucket are available:

- bucket name validation
- public access blocking
- server-side encryption
- enforce Secure Transport
- versioning (optional)
- access logging (optional)

The following features of the DynamoDB table are available:

- table name validation
- deletion protection
- point-in-time recovery (optional)
- Cross-Region Replication (optional)

## Usage

### Minimal S3 Usage

```hcl
module "s3_backend" {
  source = "git@github.com:ZombieChamp/S3-Backend.git"

  s3_bucket = {
    name = "bestproject-terraform-backend"
  }
}
```

### Minimal S3 and DynamoDB Usage

```hcl
module "s3_backend" {
  source = "git@github.com:ZombieChamp/S3-Backend.git"

  s3_bucket = {
    name = "bestproject-terraform-backend"
  }

  dynamodb_table = {
    name = "terraform-state-lock"
  }
}
```

### S3 and DynamoDB Usage With All Security Features Enabled

```hcl
data "aws_s3_bucket" "log_bucket" {
  bucket = "bestproject-logs"
}


module "s3_backend" {
  source = "git@github.com:ZombieChamp/S3-Backend.git"

  s3_bucket = {
    name           = "bestproject-terraform-backend"
    versioning     = true
    logging_bucket = data.aws_s3_bucket.log_bucket.id
  }

  dynamodb_table = {
    name                   = "terraform-state-lock"
    point_in_time_recovery = true
    replica_region_names = [
      "eu-west-2",
      "us-west-1",
    ]
  }
}
```

## Examples:

TODO: Add examples

## Requirements

TODO: Figure out minimum versions

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.67 |

## Providers

TODO: Figure out minimum versions

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.67 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_iam_policy_document.deny_unsecure_communications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

TODO: Add Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|

## Outputs

| Name | Description |
|------|-------------|
| [s3_bucket_id]() | The name of the bucket. |
| [s3_bucket_arn]() | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| [s3_bucket_domain_name]() | The bucket domain name. Will be of format bucketname.s3.amazonaws.com. |
| [s3_bucket_regional_domain_name]() | The bucket region-specific domain name. The bucket domain name including the region name. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL. |
| [s3_bucket_hosted_zone_id]() | The Route 53 Hosted Zone ID for this bucket's region. |
| [s3_bucket_region]() | The AWS region this bucket resides in. |
| [dynamodb_table_arn]() | The ARN of the table. |
| [dynamodb_table_id]() | The name of the table. |
| [dynamodb_table_replica_arns]() | The ARN(s) of the replica(s). |

## Authors

Module is maintained by [Matthew Mawson](https://github.com/ZombieChamp)

## License

GNU General Public Licensed. See [LICENSE](https://github.com/ZombieChamp/S3-Backend/blob/development/LICENCE) for full details.
