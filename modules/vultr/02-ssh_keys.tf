locals {
  filename_rsa_prv_key     = "./keys/github_ssh_private.key"
  filename_rsa_pub_key     = "./keys/github_ssh_public.key"
  filename_ed25519_prv_key = "./keys/github_ed25519_private.key"
  filename_ed25519_pub_key = "./keys/github_ed25519_public.key"

}
resource "tls_private_key" "ED25519" {
  algorithm   = "ED25519"
  ecdsa_curve = "P384"
}

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_openssh" {
  content    = tls_private_key.rsa_4096.public_key_openssh
  filename   = local.filename_rsa_prv_key
  depends_on = [tls_private_key.rsa_4096]
  provisioner "local-exec" {
    command = "find ./keys -type f -exec chmod 0600 {} \\;"
  }
}

resource "local_file" "public_key_openssh" {
  content    = tls_private_key.rsa_4096.private_key_openssh
  filename   = local.filename_rsa_pub_key
  depends_on = [tls_private_key.rsa_4096]
  provisioner "local-exec" {
    command = "find ./keys -type f -exec chmod 0600 {} \\;"
  }
}

resource "local_file" "private_key_ecdsa" {
  content    = tls_private_key.ED25519.private_key_openssh
  filename   = local.filename_ed25519_prv_key
  depends_on = [tls_private_key.ED25519]
  provisioner "local-exec" {
    command = "find ./keys -type f -exec chmod 0600 {} \\;"
  }
}

resource "local_file" "public_key_ecdsa" {
  content    = tls_private_key.ED25519.public_key_openssh
  filename   = local.filename_ed25519_pub_key
  depends_on = [tls_private_key.ED25519]
  provisioner "local-exec" {
    command = "find ./keys -type f -exec chmod 0600 {} \\;"
  }
}
