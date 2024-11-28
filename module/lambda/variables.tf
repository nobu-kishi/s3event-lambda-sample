variable "app_name" {
  type        = string
  description = "アプリ名"
}

variable "env" {
  type        = string
  description = "dev,stag,prdのいずれかを表す環境名"
}

variable "s3_bucket_id" {
  type        = string
  description = "S3ARN"
}

variable "s3_bucket_arn" {
  type        = string
  description = "S3のARN"
}

variable "dynamodb_table_arn" {
  type        = string
  description = "DynamoDBのARN"
}


# variable "function_name" {
#   type        = string
#   description = "{環境のprefix}-アプリ名"
# }

# variable "runtime" {
#   type        = string
#   description = "Lambda上で実行するランタイム"
# }

# variable "source_code_path" {}


# variable "memory_size" {
#   default = 128
# }

# variable "timeout" {
#   default = 30
# }

