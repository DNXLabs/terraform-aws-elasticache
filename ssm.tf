resource "aws_ssm_parameter" "redis_endpoint" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/elasticache/redis/${var.env}-${var.name}/ENDPOINT"
  description = "Elasticache Redis Endpoint"
  type        = "String"
  value       = aws_elasticache_replication_group.redis.cluster_enabled ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.primary_endpoint_address
}
resource "aws_ssm_parameter" "redis_port" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/elasticache/redis/${var.env}-${var.name}/PORT"
  description = "Elasticache Redis Port"
  type        = "String"
  value       = aws_elasticache_replication_group.redis.port
}