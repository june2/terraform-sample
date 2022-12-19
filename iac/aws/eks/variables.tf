

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "108199670400",    
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [    
    {
      userarn  = "arn:aws:iam::108199670400:root"
      username = "root"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::108199670400:user/terraform"
      username = "terraform"
      groups   = ["system:masters"]
    }
  ]
}
