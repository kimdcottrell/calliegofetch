# ---------------------------------------------------------------------------------------------------------------------
# SCPs
# Each module is a reference to a possible list of scp's
# ---------------------------------------------------------------------------------------------------------------------

module "scps__root_children" {
  ###
  # Apply SCP's to the Org Root's immediate children.
  # > AWS strongly recommends that you don't attach SCPs to the root of your
  #   organization without thoroughly testing the impact that the policy has
  #   on accounts.
  # - https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html
  ###
  source = "./modules/scps/root_children"
  root_children_org_units = aws_organizations_organizational_unit.root_children
}
