# ---------------------------------------------------------------------------------------------------------------------
# CREATE ACCOUNTS UNDER OU'S
# Accounts are managed in a single yaml file within the locals block.
# Thanks to string interpolation not being allowed in resource references,
# the parent_id must be manually defined. This is why 2 duplicative-ish
# resources must presently exist.
# TODO: Can a module make it so the resource duplication goes away?
# ---------------------------------------------------------------------------------------------------------------------

locals {
  ou_accounts = yamldecode(file("./config/accounts.yaml"))["Root_Level"]
  workloads_sub_accounts = yamldecode(file("./config/accounts.yaml"))["Workloads_Level"]
}

resource "aws_organizations_account" "root_child_ou" {
  count = length(local.ou_accounts)
  name  = local.ou_accounts[count.index].name
  email = local.ou_accounts[count.index].email
  parent_id = aws_organizations_organizational_unit.root_children[local.ou_accounts[count.index].ou_child].id
  iam_user_access_to_billing = local.ou_accounts[count.index].iam_user_access_to_billing

  lifecycle {
    # This resource's close_on_deletion flag does not work as expected.
    # AWS keeps organization accounts around for a minimum of 7 days. https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_remove.html#orgs_manage_account-before-remove
    # This can block you from further IaC changes if you're not careful.
    # So, let's force a code edit so you have to read this block instead of screwing yourself via `terraform delete`
    prevent_destroy = true
    # If this is enabled, it will force `terraform replace`, but we are preventing destroys
    ignore_changes = [iam_user_access_to_billing]
  }
}

resource "aws_organizations_account" "workloads_child_ou" {
  count = length(local.workloads_sub_accounts)
  name  = local.workloads_sub_accounts[count.index].name
  email = local.workloads_sub_accounts[count.index].email
  parent_id = aws_organizations_organizational_unit.workloads_children[local.workloads_sub_accounts[count.index].ou_child].id
  iam_user_access_to_billing = local.workloads_sub_accounts[count.index].iam_user_access_to_billing
  lifecycle {
    prevent_destroy = true
    ignore_changes = [iam_user_access_to_billing]
  }
}
