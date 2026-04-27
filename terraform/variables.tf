variable "port_client_id" {
  type        = string
  description = "Port Client ID — find this in Port under Settings > Credentials"
}

variable "port_client_secret" {
  type        = string
  sensitive   = true
  description = "Port Client Secret — find this in Port under Settings > Credentials"
}
