#This policy comes from "DenyAllExceptListedIfNoMFA" https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_my-sec-creds-self-manage.html
data "aws_iam_policy_document" "test_apply_to_only_engineering" {
  statement {
    sid = "TESTRequireMFA"

    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice",
      "sts:GetSessionToken",
    ]

    resources = [
      "*",
    ]

    effect = "Deny"

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "false",
      ]
    }
  }
}

resource "aws_organizations_policy" "test_apply_to_only_engineering" {
  name        = "TEST - Only Apply to Engineering OU"
  description = "This will later get deleted..."

  content = data.aws_iam_policy_document.test_apply_to_only_engineering.json
}

resource "aws_organizations_policy_attachment" "test_apply_to_only_engineering" {
  policy_id = aws_organizations_policy.test_apply_to_only_engineering.id
  target_id = var.root_children_org_units["Engineering"].id
}
