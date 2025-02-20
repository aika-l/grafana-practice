   terraform {
     backend "s3" {
       bucket = "group5-grafana-practice"
       key    = "terraform.tfstate"
       region = "us-east-1"
       encrypt = true
  }
}
