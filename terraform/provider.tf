terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


#sets me up with my aws account
provider "aws" {

  region = "us-east-1"

  access_key = ""
  secret_key = ""

}
