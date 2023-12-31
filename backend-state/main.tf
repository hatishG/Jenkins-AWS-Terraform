variable "aws_region" {
    default = "ap-south-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
    region = var.aws_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform_state_jenkins_setup"

    lifecycle {
      prevent_destroy = true
    }

    versioning {
      enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}
