
resource "random_id" "salt" {
  byte_length = 8
  keepers = {
    redis_version = var.redis_version
  }
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = format("%.20s", "${var.name}-${var.env}")
  replication_group_description = "Terraform-managed ElastiCache replication group for ${var.name}-${var.env}-${var.vpc_id}"
  number_cache_clusters         = var.redis_clusters
  node_type                     = var.redis_node_type
  automatic_failover_enabled    = var.redis_failover
  auto_minor_version_upgrade    = var.auto_minor_version_upgrade
  availability_zones            = var.availability_zones
  multi_az_enabled              = var.multi_az_enabled
  engine                        = "redis"
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  kms_key_id                    = var.kms_key_id
  transit_encryption_enabled    = var.transit_encryption_enabled
  auth_token                    = var.transit_encryption_enabled ? var.auth_token : null
  engine_version                = var.redis_version
  port                          = var.redis_port
  parameter_group_name          = aws_elasticache_parameter_group.redis_parameter_group.id
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.id
  security_group_names          = var.security_group_names
  security_group_ids            = [aws_security_group.redis_security_group.id]
  snapshot_arns                 = var.snapshot_arns
  snapshot_name                 = var.snapshot_name
  apply_immediately             = var.apply_immediately
  maintenance_window            = var.redis_maintenance_window
  notification_topic_arn        = var.notification_topic_arn
  snapshot_window               = var.redis_snapshot_window
  snapshot_retention_limit      = var.redis_snapshot_retention_limit
  tags                          = merge(tomap({"Name" = format("tf-elasticache-%s-%s", var.name, var.vpc_id)}), var.tags)
}

resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name = replace(format("%.255s", lower(replace("tf-redis-${var.name}-${var.env}-${var.vpc_id}-${random_id.salt.hex}", "_", "-"))), "/\\s/", "-")

  description = "Terraform-managed ElastiCache parameter group for ${var.name}-${var.env}-${var.vpc_id}"

  # Strip the patch version from redis_version var
  family = "redis${replace(var.redis_version, "/\\.[\\d]+$/", "")}"
  dynamic "parameter" {
    for_each = var.redis_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = replace(format("%.255s", lower(replace("tf-redis-${var.name}-${var.env}-${var.vpc_id}", "_", "-"))), "/\\s/", "-")
  subnet_ids =  data.aws_subnet_ids.selected.ids
}

resource "aws_ssm_parameter" "redis_ssm_parameter" {
  for_each    = { for param in try(var.redis_parameters, []) : param.name => param }
  name        = "/elasticache/redis/${var.name}-${var.env}/${each.value.name}"
  description = each.value.name
  type        = "SecureString"
  value       = each.value.value
  lifecycle {
    ignore_changes = [value]
  }
}