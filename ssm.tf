resource "aws_ssm_parameter" "redis_endpoint" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/elasticache/redis/${var.environment_name}-${var.name}/ENDPOINT"
  description = "Elasticache Redis Endpoint"
  type        = "String"
  value       = aws_elasticache_replication_group.redis[0].primary_endpoint_address
}

resource "aws_ssm_parameter" "redis_port" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/elasticache/redis/${var.environment_name}-${var.name}/PORT"
  description = "Elasticache Redis Port"
  type        = "String"
  value       = aws_elasticache_replication_group.redis[0].port
}