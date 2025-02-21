terraform {
  backend "s3" {
    bucket         = "group5-grafana-practice" # Replace with the same value as your s3 bucket on AWS Console
    key            = "terraform.tfstate"
    region         = "us-east-2" # Replace with your own value
    encrypt        = true
    use_lockfile   = true
  }
}
