resource "aws_secretsmanager_secret" "elasticache" {
  count                   = var.secret_method == "secretsmanager" ? 1 : 0
  name                    = "/elasticache/${var.env}-${var.name}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "elasticache" {
  count     = var.secret_method == "secretsmanager" ? 1 : 0
  secret_id = aws_secretsmanager_secret.elasticache[0].id
  secret_string = jsonencode({
    "REDIS_PORT" : aws_elasticache_replication_group.redis.port,
    "REDIS_HOST" : aws_elasticache_replication_group.redis.cluster_enabled ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.primary_endpoint_address,
    "REDIS_URL" : "redis://${aws_elasticache_replication_group.redis.cluster_enabled ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.primary_endpoint_address}:${aws_elasticache_replication_group.redis.port}",
  })
}