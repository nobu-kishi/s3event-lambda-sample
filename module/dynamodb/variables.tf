variable "app_name" {
  type        = string
  description = "アプリケーション名"
}

variable "env" {
  type        = string
  description = "dev,stag,prdのいずれかを表す環境名"
}

# variable "scaling_config" {
#   description = "オートスケーリング設定"
#   type = map(object({
#     min_capacity = number
#     max_capacity = number
#     target_value = number
#   }))
# }

variable "min_capacity" {
  type    = number
  default = 10
}

variable "max_capacity" {
  type    = number
  default = 10
}

variable "target_value" {
  type    = number
  default = 70
}