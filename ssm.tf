resource "aws_ssm_parameter" "redis_endpoint" {
  count       = var.secret_method == "ssm" ? 1 : 0 && var.engine_type == "redis"
  name        = "/elasticache/redis/${var.env}-${var.name}/ENDPOINT"
  description = "Elasticache Redis Endpoint"
  type        = "String"
  value       = aws_elasticache_replication_group.redis.cluster_enabled ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.primary_endpoint_address
}
resource "aws_ssm_parameter" "redis_port" {
  count       = var.secret_method == "ssm" ? 1 : 0 && var.engine_type == "redis"
  name        = "/elasticache/redis/${var.env}-${var.name}/PORT"
  description = "Elasticache Redis Port"
  type        = "String"
  value       = aws_elasticache_replication_group.redis.port
}
resource "aws_ssm_parameter" "memcached_endpoint" {
  count       = var.secret_method == "ssm" ? 1 : 0 && var.engine_type == "memcached"
  name        = "/elasticache/memcached/${var.env}-${var.name}/ENDPOINT"
  description = "Elasticache Memcached Endpoint"
  type        = "String"
  value       = aws_elasticache_cluster.memcached.cluster_address
}
resource "aws_ssm_parameter" "memcached_port" {
  count       = var.secret_method == "ssm" ? 1 : 0 && var.engine_type == "memcached"
  name        = "/elasticache/memcached/${var.env}-${var.name}/PORT"
  description = "Elasticache Redis Port"
  type        = "String"
  value       = var.memcached_port
}