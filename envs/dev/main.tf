provider "aws" {
  region = var.region
}

terraform {
  required_version = "=v1.9.8"
  required_providers {
    aws = "5.77.0"
  }
  # backend "s3" {
  #   bucket = "dev-metadata-register-sample-terraform"
  #   key    = "terraform.tfstate"
  #   region = "ap-northeast-1"
  # }
}

locals {
  app_name = "${var.env}-${var.name}"
}

module "s3" {
  source = "../../module/s3"

  app_name = local.app_name
  env      = var.env
}

module "lambda" {
  source = "../../module/lambda"

  app_name           = local.app_name
  env                = var.env
  s3_bucket_arn      = module.s3.s3_bucket_arn
  s3_bucket_id       = module.s3.s3_bucket_id
  dynamodb_table_arn = module.dynamodb.dynamodb_table_arn
}

# TODO:スケーリング設定の作り込み
module "dynamodb" {
  source = "../../module/dynamodb"

  app_name = local.app_name
  env      = var.env
  # scaling_config = var.scaling_config
  # for_each =  var.scaling_config
  # min_capacity = each.value.min_capacity
  # max_capacity = each.value.max_capacity
  # target_value = each.value.target_value
}
