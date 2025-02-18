resource "random_id" "salt" {
  byte_length = 8
  keepers = {
    engine_version = var.engine_version
  }
}
