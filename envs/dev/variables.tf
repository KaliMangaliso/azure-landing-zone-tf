variable "location" { type = string }
variable "tenant_id" { type = string }
variable "allowed_locations" { type = list(string) }
variable "tags" {
  type    = map(string)
  default = {}
}