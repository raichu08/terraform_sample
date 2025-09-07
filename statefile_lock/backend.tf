terraform {
    backend "s3" {
        bucket = "myterragaganlock"
        region = "us-east-2"
        key = "terraform.tfstate"
        dynamodb_table = "terraform-lock"
        encrypt = true
    }
}
