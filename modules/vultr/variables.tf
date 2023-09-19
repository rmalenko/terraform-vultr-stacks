variable "firewall_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "region" {
  type = string
}

variable "ssh_key_name" {
  type        = list(string)
  description = "SSH key name from Vultr"
}

variable "instance" {
  type = map(object({
    instance_tags    = list(any),
    plan             = string,
    os_id            = string,
    enable_ipv6      = bool,
    backups          = string,
    backups_schedule = string,
    backups_dow      = string,
    backups_hour     = string,
    ddos_protection  = bool,
    activation_email = bool,
    cloud_config     = string,
    tz               = string,
  }))
}

variable "domain" {
  type        = string
  description = "Main public domain name"
}

variable "vultr_apikey" {
  type = string
}

variable "email_for_ssl" {
  type        = string
  description = "Email for Letsencrypt certificates in terraform"
}

variable "firewall" {
  description = "List of firewall rules"

  type = list(object({
    ip_type     = string
    protocol    = string
    subnet      = string
    subnet_size = string
    port        = any
    notes       = string
  }))
}

variable "ssh_user_name_gitact" {
  type        = string
  description = "A name to use as ssh login in Github actions"
}