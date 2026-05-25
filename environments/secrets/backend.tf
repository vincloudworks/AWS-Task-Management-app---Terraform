terraform {
  backend "s3" {
    key          = "secret/terraform.tfstate"
    region       = "ap-south-2"
    bucket       = "weekendproject1-tf-state-123456789012-ap-south-2"
    use_lockfile   = true
  }
}