resource "vultr_vpc" "vpc" {
  description    = var.vpc_name
  region         = var.region
  v4_subnet      = "10.0.0.0"
  v4_subnet_mask = 8
}
