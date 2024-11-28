variable "region" {
  type        = string
  description = "使用するAWSリージョン"
}

variable "name" {
  type = string
}

variable "env" {
  type        = string
  description = "dev,stag,prdのいずれかを表す環境名"
}

# variable "scaling_config" {
#   description = "オートスケーリング設定"
#   type = map(object({
#     min_capacity       = number
#     max_capacity       = number
#     target_value       = number
#   }))
# }

# variable "scaling_config" {
#   description = "オートスケーリング設定"
#   type = map {
#     min_capacity       = number
#     max_capacity       = number
#     target_value       = number
#   }
# }