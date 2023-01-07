# s3 bucket creation
resource "aws_s3_bucket" "tf-state-storage-s3" {
	bucket = var.s3-name
 	acl    = "private"
	versioning { 
		 enabled = true
		}
	lifecycle { 
		prevent_destroy = true
		}	 
}


resource "aws_s3_bucket_public_access_block" "tf-s3-b-access" {
  bucket = aws_s3_bucket.tf-state-storage-s3.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

#create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
	name = var.dydb-lock 
	hash_key = "LockID"
	read_capacity = 20
	write_capacity = 20
	attribute {
		name = "LockID" 
		type = "S"
		}
	}
