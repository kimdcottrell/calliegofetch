# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  default = "us-east-1"
}

variable "access_key" {
  sensitive = true
}

variable "secret_key" {
  sensitive = true
}
