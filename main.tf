
resource "random_id" "salt" {
  byte_length = 8
  keepers = {
    redis_version = var.redis_version
  }
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = format("%.20s", "${var.name}-${var.env}")
  description                = "Terraform-managed ElastiCache replication group for ${var.name}-${var.env}-${var.vpc_id}"
  node_type                  = var.redis_node_type
  automatic_failover_enabled = var.redis_failover
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  multi_az_enabled           = var.multi_az_enabled
  engine                     = "redis"
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  kms_key_id                 = var.kms_key_id
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.transit_encryption_enabled ? var.auth_token : null
  engine_version             = var.redis_version
  port                       = var.redis_port
  parameter_group_name       = aws_elasticache_parameter_group.redis_parameter_group.id
  subnet_group_name          = try(aws_elasticache_subnet_group.redis_subnet_group[0].id, var.redis_subnet_group_id)
  security_group_names       = var.security_group_names
  security_group_ids         = [aws_security_group.redis_security_group.id]
  snapshot_arns              = var.snapshot_arns
  snapshot_name              = var.snapshot_name
  apply_immediately          = var.apply_immediately
  maintenance_window         = var.redis_maintenance_window
  notification_topic_arn     = var.notification_topic_arn
  snapshot_window            = var.redis_snapshot_window
  snapshot_retention_limit   = var.redis_snapshot_retention_limit
  tags                       = merge(tomap({ "Name" = format("tf-elasticache-%s-%s", var.name, var.vpc_id) }), var.tags)
  num_node_groups            = var.redis_cluster_enable ? var.redis_cluster_num_node_groups : null
  replicas_per_node_group    = var.redis_cluster_enable ? var.redis_cluster_replicas_per_node_group : null
  user_group_ids             = var.user_group_ids
}

resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name = replace(format("%.255s", lower(replace("tf-redis-${var.name}-${var.env}-${var.vpc_id}-${random_id.salt.hex}", "_", "-"))), "/\\s/", "-")

  description = "Terraform-managed ElastiCache parameter group for ${var.name}-${var.env}-${var.vpc_id}"

  # Strip the patch version from redis_version var
  # family = "redis${replace(var.redis_version, "/\\.[\\d]+$/", "")}"
  family = local.major_version >= 7 ? "redis${local.major_version}" : (local.major_version == 6 ? "redis${local.major_version}.x" : "redis${replace(var.redis_version, "/\\.[\\d]+$/", "")}")
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
  count      = var.create_redis_subnet_group ? 1 : 0
  name       = replace(format("%.255s", lower(replace("tf-redis-${var.name}-${var.env}-${var.vpc_id}", "_", "-"))), "/\\s/", "-")
  subnet_ids = data.aws_subnets.selected.ids
}
