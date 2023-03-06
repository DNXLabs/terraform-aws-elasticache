resource "aws_secretsmanager_secret" "elasticache" {
  count                   = var.secret_method == "secretsmanager" ? 1 : 0
  name                    = "/elasticache/${var.env}-${var.name}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "elasticache" {
  count     = var.secret_method == "secretsmanager" ? 1 : 0 && var.engine_type == "redis"
  secret_id = aws_secretsmanager_secret.elasticache[0].id
  secret_string = jsonencode({
    "REDIS_PORT" : aws_elasticache_replication_group.redis.port,
    "REDIS_HOST" : aws_elasticache_replication_group.redis.cluster_enabled ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.primary_endpoint_address,
    "REDIS_URL" : "redis${var.transit_encryption_enabled ? "s" : ""}://${aws_elasticache_replication_group.redis.cluster_enabled ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.primary_endpoint_address}:${aws_elasticache_replication_group.redis.port}",
  })
}
resource "aws_secretsmanager_secret_version" "memcached_secrets" {
  count     = var.secret_method == "secretsmanager" ? 1 : 0 && var.engine_type == "memcached"
  secret_id = aws_secretsmanager_secret.elasticache[0].id
  secret_string = jsonencode({
    "MEMCACHED_PORT" : var.memcached_port
    "MEMCACHED_URL" : aws_elasticache_cluster.memcached.cluster_address
  })
}