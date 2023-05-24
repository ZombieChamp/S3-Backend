variable "s3_bucket" {
  type = object({
    name           = string
    versioning     = optional(bool, false)
    logging_bucket = optional(string, null)
  })

  description = "The S3 Bucket containing the Terraform State."

  validation {
    condition     = length(var.s3_bucket["name"]) >= 3 && length(var.s3_bucket["name"]) <= 63
    error_message = "Bucket names must be between 3 (min) and 63 (max) characters long."
  }

  validation {
    condition     = can(regex("^[a-z0-9.-]*$", var.s3_bucket["name"]))
    error_message = "Bucket names can consist only of lowercase letters, numbers, dots (.), and hyphens (-)."
  }

  validation {
    condition     = can(regex("^[a-z0-9].*[a-z0-9]$", var.s3_bucket["name"]))
    error_message = "Bucket names must begin and end with a letter or number."
  }

  validation {
    condition     = !can(regex(".*[.][.].*", var.s3_bucket["name"]))
    error_message = "Bucket names must not contain two adjacent periods."
  }

  validation {
    condition     = !can(cidrnetmask("${var.s3_bucket["name"]}/32"))
    error_message = "Bucket names must not be formatted as an IP address (for example, 192.168.5.4)."
  }

  validation {
    condition     = !startswith(var.s3_bucket["name"], "xn--")
    error_message = "Bucket names must not start with the prefix xn--."
  }

  validation {
    condition     = !endswith(var.s3_bucket["name"], "-s3alias")
    error_message = "Bucket names must not end with the suffix -s3alias. This suffix is reserved for access point alias names. For more information, see Using a bucket-style alias for your S3 bucket access point (https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points-alias.html)."
  }

  validation {
    condition     = !endswith(var.s3_bucket["name"], "--ol-s3")
    error_message = "Bucket names must not end with the suffix --ol-s3. This suffix is reserved for Object Lambda Access Point alias names. For more information, see How to use a bucket-style alias for your S3 bucket Object Lambda Access Point (https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-use.html#ol-access-points-alias)."
  }
}

variable "dynamodb_table" {
  type = object({
    name                   = optional(string, null)
    point_in_time_recovery = optional(bool, false)
    replica_regions        = optional(list(string), [])
  })

  default = {}

  description = "Settings for the DynamoDB used for Locking the Terraform State."

  validation {
    condition     = var.dynamodb_table["name"] == null ? true : length(var.dynamodb_table["name"]) >= 3 && length(var.dynamodb_table["name"]) <= 255
    error_message = "Table names must be between 3 (min) and 255 (max) characters long."
  }

  validation {
    condition     = var.dynamodb_table["name"] == null ? true : can(regex("^[a-zA-Z0-9_.-]*$", var.dynamodb_table["name"]))
    error_message = "Table names can consist only of letters, numbers, underscores (_), dots (.), and hyphens (-)."
  }
}
