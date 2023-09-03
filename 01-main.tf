# The instance is a map of the number of instances. Each key is the name of the server and subdomain.
module "vultr" {
  source        = "./modules"
  domain        = "jazzfest.link"
  firewall_name = "External HTTP, SSH"
  vpc_name      = "A beautiful name of my VPC"
  region        = var.region_frankfurt_de
  vultr_apikey  = var.VULTR_API_KEY
  # List of server configurations
  instance = {
    app-server = {
      instance_tags    = ["go", "app"]
      ssh_key_name     = ["rostyslav"]
      plan             = var.plan_5_usd_vc2-1c-1gb
      os_id            = var.os_id_ubuntu_22_04_lts
      enable_ipv6      = true
      backups          = "enabled"
      backups_schedule = "monthly"
      backups_dow      = 6
      backups_hour     = 1
      ddos_protection  = false
      activation_email = false
      cloud_config     = "cloud_config_app_server.yaml"
      tz               = "Europe/Kiev"
    },
    # db-server = {
    #   instance_tags    = ["go", "db"]
    #   ssh_key_name     = ["rostyslav"]
    #   plan             = var.plan_5_usd_vc2-1c-1gb
    #   os_id            = var.os_id_ubuntu_22_04_lts
    #   enable_ipv6      = false
    #   backups          = "enabled"
    #   backups_schedule = "monthly"
    #   backups_dow      = 6
    #   backups_hour     = 1
    #   ddos_protection  = false
    #   activation_email = false
    #   cloud_config     = "cloud_config_db_server.yaml"
    #   tz               = "Europe/Berlin"
    # }
  }
}
# Man. DateTime::TimeZone::Catalog.3pm.gz
# https://manpages.ubuntu.com/manpages/focal/man3/DateTime::TimeZone::Catalog.3pm.html¸

