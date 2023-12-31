terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.15.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
}

# Configure the Vultr Provider
provider "vultr" {
  api_key     = var.VULTR_API_KEY
  rate_limit  = 300
  retry_limit = 3
}

provider "github" {
  token = var.GITHUB_TOKEN
}