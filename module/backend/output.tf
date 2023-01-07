output "backend_bucket" {
  value = aws_s3_bucket.tf-state-storage-s3.id
}

output "backend_dynamodb" {
  value = aws_dynamodb_table.dynamodb-terraform-state-lock.id
}
