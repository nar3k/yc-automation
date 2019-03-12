output "external_ip_addresses" {
  value = "${local.external_ips}"
}



output "internal_ip_addresses" {
  value = "${local.internal_ips}"
}


output "subnet_ids" {
  value = "${local.subnet_ids}"
}


output "folder_id" {
  value = "${var.folder_id}"
}
