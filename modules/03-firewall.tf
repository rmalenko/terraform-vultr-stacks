# Firewall configuration
resource "vultr_firewall_group" "firewallgroups" {
  # count       = var.firewall_name != "" ? 1 : 0
  description = var.firewall_name
}

# SSH 
resource "vultr_firewall_rule" "sshv4" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = 22
  notes             = "Allow SSH connections"
}

resource "vultr_firewall_rule" "sshv6" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = 22
  notes             = "Allow SSH"
}

# Add a firewall rule to the group allowing HTTP IPv4 access.
resource "vultr_firewall_rule" "httpv4" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = 80
  notes             = "Allow HTTP"
}

resource "vultr_firewall_rule" "lego_httpv4" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "81-82"
  notes             = "Allow HTTP for Lego to obtain SSL certificates from Letsencrypt"
}

# Add a firewall rule to the group allowing HTTP IPv6 access.
resource "vultr_firewall_rule" "httpv6" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = 80
  notes             = "Allow HTTP"
}

# Add a firewall rule to the group allowing HTTPS IPv4 access.
resource "vultr_firewall_rule" "httpsv4" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = 443
  notes             = "Allow HTTPS"
}

# Add a firewall rule to the group allowing HTTPS IPv6 access.
resource "vultr_firewall_rule" "httpsv6" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = 443
  notes             = "Allow HTTPS"
}

resource "vultr_firewall_rule" "icmp4" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  protocol          = "icmp"
}

resource "vultr_firewall_rule" "icmp6" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  protocol          = "icmp"
}

# Allow access from a Prometheus server to the port of node_exporter
resource "vultr_firewall_rule" "node_exporter4" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "127.0.0.1" # Add task of get IP address of Prometheus server.
  subnet_size       = 0
  port              = 9100
  notes             = "Allow Prometheus to node_exporter"
}

resource "vultr_firewall_rule" "node_exporter6" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::1" # Add task of get IP address of Prometheus server.
  subnet_size       = 0
  port              = 9100
  notes             = "Allow Prometheus to node_exporter"
}

# Allow access from a Prometheus server to the port of docker exporter
resource "vultr_firewall_rule" "docker_exporter4" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "127.0.0.1" # Add task of get IP address of Prometheus server.
  subnet_size       = 0
  port              = 9323
  notes             = "Allow Prometheus to docker exporter"
}

resource "vultr_firewall_rule" "docker_exporter6" {
  # count             = var.firewall_name != "" ? 1 : 0
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::1" # Add task of get IP address of Prometheus server.
  subnet_size       = 0
  port              = 9323
  notes             = "Allow Prometheus to docker exporter"
}
