resource "aws_elasticache_serverless_cache" "this" {
  count         = var.node_type == "serverless" ? 1 : 0
  engine        = var.engine
  name          = var.name
  description   = "Terraform-managed ElastiCache replication group for ${var.name}-${var.env}-${var.vpc_id}"
  
  dynamic "cache_usage_limits" {
    for_each    = var.cache_usage_limits
    content {
      data_storage {
        minimum = cache_usage_limits.value.data_storage.minimum
        maximum = cache_usage_limits.value.data_storage.maximum
        unit    = cache_usage_limits.value.data_storage.unit
      }
      ecpu_per_second {
        minimum = cache_usage_limits.value.ecpu_per_second.minimum
        maximum = cache_usage_limits.value.ecpu_per_second.maximum
      }
    }
  }

  daily_snapshot_time      = trimspace(split("-", var.snapshot_window)[0])
  kms_key_id               = var.kms_key_id
  major_engine_version     = var.engine_version
  snapshot_retention_limit = var.snapshot_retention_limit
  security_group_ids       = [aws_security_group.default.id]
  subnet_ids               = data.aws_subnets.selected.ids
  tags                     = merge(tomap({ "Name" = format("tf-elasticache-%s-%s", var.name, var.vpc_id) }), var.tags)
}