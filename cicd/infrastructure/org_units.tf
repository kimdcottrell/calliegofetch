# ---------------------------------------------------------------------------------------------------------------------
# CREATE OU's UNDER ORGANIZATION
# Thanks to string interpolation not being allowed in resource references,
# the parent_id must be manually defined. This is why 2 duplicative-ish
# resources must presently exist.
# TODO: Can a module make it so the resource duplication goes away?
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_organizations_organizational_unit" "root_children" {
  for_each  = toset( ["Engineering", "Exceptions", "Workloads"] )
  name      = each.key
  parent_id = data.aws_organizations_organization.org.roots[0].id

  lifecycle {
    # This can block you from further IaC changes if you're not careful.
    # So, let's force a code edit so you have to read this block instead of screwing yourself via `terraform delete`
    prevent_destroy = true
  }
}

resource "aws_organizations_organizational_unit" "workloads_children" {
  for_each  = toset( ["Pre-Prod", "Prod"] )
  name      = each.key
  parent_id = aws_organizations_organizational_unit.root_children["Workloads"].id

  lifecycle {
    prevent_destroy = true
  }
}
