resource "aws_elasticache_replication_group" "default" {
  # count = contains(["redis", "valkey"], var.engine) && var.redis_clusters > 1 && var.redis_cluster_enable ? var.redis_clusters : 0
  count                      = contains(["redis", "valkey"], var.engine) ? 1 : 0
  replication_group_id       = format("%.20s", "${var.name}-${var.env}")
  description                = "Terraform-managed ElastiCache replication group for ${var.name}-${var.env}-${var.vpc_id}"
  node_type                  = var.node_type
  automatic_failover_enabled = var.failover_enabled
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  multi_az_enabled           = var.multi_az_enabled
  engine                     = var.engine
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  kms_key_id                 = var.kms_key_id
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.transit_encryption_enabled ? var.auth_token : null
  engine_version             = var.engine_version
  port                       = var.port
  parameter_group_name       = aws_elasticache_parameter_group.parameter_group.id
  subnet_group_name          = try(aws_elasticache_subnet_group.default[0].id, var.subnet_group_id)
  security_group_names       = var.security_group_names
  security_group_ids         = [aws_security_group.default.id]
  snapshot_arns              = var.snapshot_arns
  snapshot_name              = var.snapshot_name
  apply_immediately          = var.apply_immediately
  maintenance_window         = var.maintenance_window
  notification_topic_arn     = var.notification_topic_arn
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  tags                       = merge(tomap({ "Name" = format("tf-elasticache-%s-%s", var.name, var.vpc_id) }), var.tags)
  num_node_groups            = var.cluster_enabled ? var.cluster_num_node_groups : null
  replicas_per_node_group    = var.cluster_enabled ? var.cluster_replicas_per_node_group : null
  user_group_ids             = var.user_group_ids
}
