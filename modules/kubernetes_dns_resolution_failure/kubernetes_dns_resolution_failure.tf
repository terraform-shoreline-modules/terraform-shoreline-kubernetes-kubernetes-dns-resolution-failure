resource "shoreline_notebook" "kubernetes_dns_resolution_failure" {
  name       = "kubernetes_dns_resolution_failure"
  data       = file("${path.module}/data/kubernetes_dns_resolution_failure.json")
  depends_on = [shoreline_action.invoke_verify_dns_config,shoreline_action.invoke_dns_restart]
}

resource "shoreline_file" "verify_dns_config" {
  name             = "verify_dns_config"
  input_file       = "${path.module}/data/verify_dns_config.sh"
  md5              = filemd5("${path.module}/data/verify_dns_config.sh")
  description      = "Check the DNS server configuration and ensure that it is configured correctly. Verify that the DNS server is operational and responding to queries."
  destination_path = "/agent/scripts/verify_dns_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "dns_restart" {
  name             = "dns_restart"
  input_file       = "${path.module}/data/dns_restart.sh"
  md5              = filemd5("${path.module}/data/dns_restart.sh")
  description      = "Restart the DNS server to clear any cache or temporary issues."
  destination_path = "/agent/scripts/dns_restart.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_verify_dns_config" {
  name        = "invoke_verify_dns_config"
  description = "Check the DNS server configuration and ensure that it is configured correctly. Verify that the DNS server is operational and responding to queries."
  command     = "`chmod +x /agent/scripts/verify_dns_config.sh && /agent/scripts/verify_dns_config.sh`"
  params      = ["DNS_SERVER_IP"]
  file_deps   = ["verify_dns_config"]
  enabled     = true
  depends_on  = [shoreline_file.verify_dns_config]
}

resource "shoreline_action" "invoke_dns_restart" {
  name        = "invoke_dns_restart"
  description = "Restart the DNS server to clear any cache or temporary issues."
  command     = "`chmod +x /agent/scripts/dns_restart.sh && /agent/scripts/dns_restart.sh`"
  params      = ["DNS_SERVER_DEPLOYMENT_NAME"]
  file_deps   = ["dns_restart"]
  enabled     = true
  depends_on  = [shoreline_file.dns_restart]
}

