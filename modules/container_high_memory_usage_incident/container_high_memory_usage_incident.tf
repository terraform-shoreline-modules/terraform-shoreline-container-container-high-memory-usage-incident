resource "shoreline_notebook" "container_high_memory_usage_incident" {
  name       = "container_high_memory_usage_incident"
  data       = file("${path.module}/data/container_high_memory_usage_incident.json")
  depends_on = [shoreline_action.invoke_docker_memory_usage,shoreline_action.invoke_update_container_memory]
}

resource "shoreline_file" "docker_memory_usage" {
  name             = "docker_memory_usage"
  input_file       = "${path.module}/data/docker_memory_usage.sh"
  md5              = filemd5("${path.module}/data/docker_memory_usage.sh")
  description      = "Inefficient resource allocation for the container, causing it to consume more memory than necessary."
  destination_path = "/agent/scripts/docker_memory_usage.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_container_memory" {
  name             = "update_container_memory"
  input_file       = "${path.module}/data/update_container_memory.sh"
  md5              = filemd5("${path.module}/data/update_container_memory.sh")
  description      = "Increasing the memory allocation for the container can help reduce high memory usage incidents. This ensures that the container has enough memory to handle the workload it is running."
  destination_path = "/agent/scripts/update_container_memory.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_docker_memory_usage" {
  name        = "invoke_docker_memory_usage"
  description = "Inefficient resource allocation for the container, causing it to consume more memory than necessary."
  command     = "`chmod +x /agent/scripts/docker_memory_usage.sh && /agent/scripts/docker_memory_usage.sh`"
  params      = ["CONTAINER_ID"]
  file_deps   = ["docker_memory_usage"]
  enabled     = true
  depends_on  = [shoreline_file.docker_memory_usage]
}

resource "shoreline_action" "invoke_update_container_memory" {
  name        = "invoke_update_container_memory"
  description = "Increasing the memory allocation for the container can help reduce high memory usage incidents. This ensures that the container has enough memory to handle the workload it is running."
  command     = "`chmod +x /agent/scripts/update_container_memory.sh && /agent/scripts/update_container_memory.sh`"
  params      = ["CONTAINER_NAME","NEW_MEMORY_LIMIT"]
  file_deps   = ["update_container_memory"]
  enabled     = true
  depends_on  = [shoreline_file.update_container_memory]
}

