provider "aws" {
  region = var.region
  secret_key = var.secret_key
  access_key = var.access_key
}

data "aws_organizations_organization" "org" {}

resource "aws_organizations_organization" "org" {
  # this resource keeps trying to re-create itself, so add in an existence check
  count = data.aws_organizations_organization.org.id == "" ? 1 : 0
  aws_service_access_principals = [
    "account.amazonaws.com",
    "backup.amazonaws.com",
  ]
  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "parent_ous" {
  for_each  = toset( ["Engineering", "Exceptions", "Workloads"] )
  name      = each.key
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads_child_ous" {
  for_each  = toset( ["Pre-Prod", "Prod"] )
  name      = each.key
  parent_id = aws_organizations_organizational_unit.parent_ous["Workloads"].id
}

resource "aws_organizations_account" "operations" {
  name  = "Operations"
  email = "me+operations@kimdcottrell.com"
  parent_id = aws_organizations_organizational_unit.parent_ous["Engineering"].id
  iam_user_access_to_billing = "ALLOW"
  close_on_deletion = true
}

resource "aws_organizations_account" "exceptions" {
  name  = "CICD"
  email = "me+cicd@kimdcottrell.com"
  parent_id = aws_organizations_organizational_unit.parent_ous["Exceptions"].id
  iam_user_access_to_billing = "DENY"
  close_on_deletion = true
}

resource "aws_organizations_account" "development" {
  name  = "Development"
  email = "me+development@kimdcottrell.com"
  parent_id = aws_organizations_organizational_unit.workloads_child_ous["Pre-Prod"].id
  iam_user_access_to_billing = "DENY"
  close_on_deletion = true
}

resource "aws_organizations_account" "staging" {
  name  = "Staging"
  email = "me+staging@kimdcottrell.com"
  parent_id = aws_organizations_organizational_unit.workloads_child_ous["Pre-Prod"].id
  iam_user_access_to_billing = "DENY"
  close_on_deletion = true
}

resource "aws_organizations_account" "production" {
  name  = "Production"
  email = "me+production@kimdcottrell.com"
  parent_id = aws_organizations_organizational_unit.workloads_child_ous["Prod"].id
  iam_user_access_to_billing = "DENY"
  close_on_deletion = true
}

#
## make a user group for all admins
#resource "aws_iam_group" "administrators" {
#  name = "Administrators"
#}
#
## fetch the pre-existing AdministratorAccess policy
#data "aws_iam_policy" "administrator" {
#  name = "AdministratorAccess"
#}
#
#resource "aws_iam_group_policy_attachment" "administrator" {
#  group      = aws_iam_group.administrators.name
#  policy_arn = data.aws_iam_policy.administrator.arn
#}
#
#resource "aws_iam_user" "administrator" {
#  name = "Administrator"
#}
#
#resource "aws_iam_user_group_membership" "administrator_add_to_group" {
#  user   = aws_iam_user.administrator.name
#  groups = [aws_iam_group.administrators.name]
#}
#
#resource "aws_iam_user_login_profile" "administrator" {
#  user                     = aws_iam_user.administrator.name
#  password_reset_required  = true
#}
#
#output "password" {
#  value = aws_iam_user_login_profile.administrator.encrypted_password
#  sensitive = true
#}
#
#data "aws_caller_identity" "current" {}
#
#resource "aws_iam_access_key" "administrator" {
#  user    = aws_iam_user.administrator.name
#
#  lifecycle {
#    postcondition {
#      condition = substr(data.aws_caller_identity.current.arn, -4, -1) == "root"
#      error_message = "Delete the root user's access token and replace your Terraform secrets access token with that of the Administrator user."
#    }
#  }
#}

