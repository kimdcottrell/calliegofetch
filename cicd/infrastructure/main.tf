provider "aws" {
  region = var.region
  secret_key = var.secret_key
  access_key = var.access_key
}

# make a user group for all admins
resource "aws_iam_group" "administrators" {
  name = "Administrators"
}

# fetch the pre-existing AdministratorAccess policy
data "aws_iam_policy" "administrator" {
  name = "AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "administrator" {
  group      = aws_iam_group.administrators.name
  policy_arn = data.aws_iam_policy.administrator.arn
}

resource "aws_iam_user" "administrator" {
  name = "Administrator"
}

resource "aws_iam_user_group_membership" "administrator_add_to_group" {
  user   = aws_iam_user.administrator.name
  groups = [aws_iam_group.administrators.name]
}

resource "aws_iam_user_login_profile" "administrator" {
  user                     = aws_iam_user.administrator.name
  password_reset_required  = true
}

output "password" {
  value = aws_iam_user_login_profile.administrator.encrypted_password
  sensitive = true
}

data "aws_caller_identity" "current" {}

resource "aws_iam_access_key" "administrator" {
  user    = aws_iam_user.administrator.name

  lifecycle {
    postcondition {
      condition = substr(data.aws_caller_identity.current.arn, -4, -1) == "root"
      error_message = "Delete the root user's access token and replace your Terraform secrets access token with that of the Administrator user."
    }
  }
}



