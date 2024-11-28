# Lambda-Terraform

## 使用技術
- Terraform v1.9.8

## ディレクトリ構成
```
.
├── README.md
├── envs
│   └── dev
│       ├── main.tf
│       ├── terraform.tfvars
│       └── variable.tf
├── module
│   ├── dynamodb
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── lambda
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── s3
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── src
    └── index.py
```

## 構築方法
1. 初期化 & モジュール読み込み
```
terraform init
```

2. リソース作成
```
terraform apply
```

3. リソース削除
```
terraform destroy
```
