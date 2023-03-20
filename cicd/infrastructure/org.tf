

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ORGANIZATION
# ---------------------------------------------------------------------------------------------------------------------

data "aws_organizations_organization" "org" {}

resource "aws_organizations_organization" "org" {
  # this resource keeps trying to re-create itself for no reason, so add in an existence check hack
  count = data.aws_organizations_organization.org.id == "" ? 1 : 0

  # NOTE: THIS ONLY IS USEFUL DURING INIT
  aws_service_access_principals = [
    "account.amazonaws.com",
    "backup.amazonaws.com",
    "sso.amazonaws.com"
  ]
  feature_set = "ALL"
  lifecycle {
    prevent_destroy = true
  }
}






