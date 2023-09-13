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
