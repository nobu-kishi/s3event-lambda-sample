variable "app_name" {
  type        = string
  description = "アプリケーション名"
}

variable "env" {
  type        = string
  description = "dev,stag,prdのいずれかを表す環境名"
}