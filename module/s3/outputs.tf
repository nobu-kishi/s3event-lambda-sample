output "s3_bucket_id" {
  value = aws_s3_bucket.file_storage.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.file_storage.arn
}