#cloud-config
${yamlencode({
  
  "package_update" = false,
  "package_upgrade"= false,
  "timezone" = timezone # https://manpages.ubuntu.com/manpages/trusty/man3/DateTime::TimeZone::Catalog.3pm.html
  
})}
