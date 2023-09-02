variable "firewall_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "region" {
  type = string
}

variable "instance" {
  type = map(object({
    instance_tags    = list(any),
    ssh_key_name     = list(string),
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
    # ansible_playbook = string
  }))
}

variable "domain" {
  type        = string
  description = "Main public domain name"
}

variable "vultr_apikey" {
  type = string
}