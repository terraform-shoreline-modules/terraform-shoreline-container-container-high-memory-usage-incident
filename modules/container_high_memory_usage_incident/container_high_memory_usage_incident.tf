resource "shoreline_notebook" "container_high_memory_usage_incident" {
  name       = "container_high_memory_usage_incident"
  data       = file("${path.module}/data/container_high_memory_usage_incident.json")
  depends_on = [shoreline_action.invoke_mem_usage_threshold,shoreline_action.invoke_update_container_memory_limit]
}

resource "shoreline_file" "mem_usage_threshold" {
  name             = "mem_usage_threshold"
  input_file       = "${path.module}/data/mem_usage_threshold.sh"
  md5              = filemd5("${path.module}/data/mem_usage_threshold.sh")
  description      = "Inefficient resource allocation for the container, causing it to consume more memory than necessary."
  destination_path = "/agent/scripts/mem_usage_threshold.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_container_memory_limit" {
  name             = "update_container_memory_limit"
  input_file       = "${path.module}/data/update_container_memory_limit.sh"
  md5              = filemd5("${path.module}/data/update_container_memory_limit.sh")
  description      = "Increasing the memory allocation for the container can help reduce high memory usage incidents. This ensures that the container has enough memory to handle the workload it is running."
  destination_path = "/agent/scripts/update_container_memory_limit.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_mem_usage_threshold" {
  name        = "invoke_mem_usage_threshold"
  description = "Inefficient resource allocation for the container, causing it to consume more memory than necessary."
  command     = "`chmod +x /agent/scripts/mem_usage_threshold.sh && /agent/scripts/mem_usage_threshold.sh`"
  params      = ["CONTAINER_ID"]
  file_deps   = ["mem_usage_threshold"]
  enabled     = true
  depends_on  = [shoreline_file.mem_usage_threshold]
}

resource "shoreline_action" "invoke_update_container_memory_limit" {
  name        = "invoke_update_container_memory_limit"
  description = "Increasing the memory allocation for the container can help reduce high memory usage incidents. This ensures that the container has enough memory to handle the workload it is running."
  command     = "`chmod +x /agent/scripts/update_container_memory_limit.sh && /agent/scripts/update_container_memory_limit.sh`"
  params      = ["CONTAINER_NAME","NEW_MEMORY_LIMIT"]
  file_deps   = ["update_container_memory_limit"]
  enabled     = true
  depends_on  = [shoreline_file.update_container_memory_limit]
}

