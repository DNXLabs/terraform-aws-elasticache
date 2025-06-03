resource "random_id" "salt" {  
  count       = var.node_type != "serverless" ? 1 : 0
  byte_length = 8
  keepers = {
    engine_version = var.engine_version
  }
}
