data "aws_iam_policy_document" "force_account_to_stay_in_org" {
  statement {
    sid = "ForceAccountToStayInOrg"

    actions = [
      "organizations:LeaveOrganization",
    ]

    resources = [
      "*",
    ]

    effect = "Deny"
  }
}

resource "aws_organizations_policy" "force_account_to_stay_in_org" {
  name        = "Force Account to Stay in Organization"
  description = "Deny an Account from Leaving an AWS Organization"

  content = data.aws_iam_policy_document.force_account_to_stay_in_org.json
}

resource "aws_organizations_policy_attachment" "force_account_to_stay_in_org" {
  for_each  = var.root_children_org_units
  policy_id = aws_organizations_policy.force_account_to_stay_in_org.id
  target_id = each.value.id
}
