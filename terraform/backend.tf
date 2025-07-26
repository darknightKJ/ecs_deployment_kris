terraform {
  backend "s3" {
    bucket = "sctp-ce10-tfstate"
    key = "kael-cicd.tfstate"
    region = "ap-southeast-1"
  }
}