variable "gcp_json" {
  type = string
  description = "Name of JSON file granting access to Google Cloud Platform project"
}
variable "gcp_project_name" {
  type = string
  description = "Name of GCP project to connect"
}
variable "region" {
  type = string
  default = "us-west1"
  description = "GCP Compute Engine Region"
}
variable "zone" {
  type = string
  default = "us-west1-a"
  description = "GCP Compute Engine Zone"
}
variable "vm_type" {
  type = string
  default = "f1-micro"
  description = "GCP Compute Engine machine type"
}
variable "ssh_key_pub" {
  type = string
  description = "Public RSA key for ssh client connetion format: 'login:openssh key string'"
}
variable "netdata_token" {
  type = string
  description = "Token for Netdata Cloud monitoring"
}
