terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source = "tfproviders/aws"
      version = "4.66.0"
    }
  }
}
