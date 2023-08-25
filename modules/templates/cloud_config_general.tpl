#cloud-config
${yamlencode({
  
  "package_update" = true,
  "package_upgrade"= true,
  "timezone" = timezone # https://manpages.ubuntu.com/manpages/trusty/man3/DateTime::TimeZone::Catalog.3pm.html
  
})}
