# versions.tf contains the Terraform configuration block (https://www.terraform.io/language/settings).
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "terraform-remote-state-201743370211-us-east-2"
    region = "us-east-2"
    # Hardcoding\workarounds is required here:  see https://github.com/hashicorp/terraform/issues/13022
    key            = "JSTEST-9a246dd-26-remote-delivery-enbl-idp-mvp"
    dynamodb_table = "terraform-remote-state-201743370211-us-east-2"
    profile        = "default"
  }
}
