terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.15.1"
    }
  }
}

# Configure the Vultr Provider
provider "vultr" {
  api_key     = var.VULTR_API_KEY
  rate_limit  = 300
  retry_limit = 3
}