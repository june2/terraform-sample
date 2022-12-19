terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-2"
}

data "aws_iam_instance_profile" "mos-ssm-role-ec2" {
  name = "MosSSMRoleForEC2"
}

resource "aws_instance" "mos-datadog-rds-agent" {
  ami                    = "ami-0fd0765afb77bcca7"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-06edd6b095fcd2cc6"
  iam_instance_profile   = data.aws_iam_instance_profile.mos-ssm-role-ec2.role_name
  vpc_security_group_ids = []
  root_block_device {
    delete_on_termination = true
    volume_size           = 30
    volume_type           = "gp2"
  }
  tags = {
    Name = "mos-datadog-rds-agent-${terraform.workspace}"
  }
}
