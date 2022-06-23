# resource "aws_ssm_parameter" "redis_endpoint" {
#   name        = "/elasticache/redis/${var.env}-${var.name}/ENDPOINT"
#   description = "Elasticache Redis Endpoint"
#   type        = "String"
#   value       = aws_elasticache_replication_group.redis.primary_endpoint_address
# }

resource "aws_ssm_parameter" "redis_port" {
  name        = "/elasticache/redis/${var.env}-${var.name}/PORT"
  description = "Elasticache Redis Port"
  type        = "String"
  value       = aws_elasticache_replication_group.redis.port
}