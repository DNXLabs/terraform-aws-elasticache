resource "aws_secretsmanager_secret" "elasticache" {
  count                   = var.secret_method == "secretsmanager" ? 1 : 0
  name                    = "/elasticache/${var.env}-${var.name}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "elasticache" {
  count     = var.secret_method == "secretsmanager" ? 1 : 0
  secret_id = aws_secretsmanager_secret.elasticache[0].id
  secret_string = jsonencode({
    "PORT" : aws_elasticache_replication_group.default.port,
    "HOST" : aws_elasticache_replication_group.default.cluster_enabled ? aws_elasticache_replication_group.default.configuration_endpoint_address : aws_elasticache_replication_group.default.primary_endpoint_address,
    "URL" : "redis${var.transit_encryption_enabled ? "s" : ""}://${aws_elasticache_replication_group.default.cluster_enabled ? aws_elasticache_replication_group.default.configuration_endpoint_address : aws_elasticache_replication_group.default.primary_endpoint_address}:${aws_elasticache_replication_group.default.port}",
  })
}
