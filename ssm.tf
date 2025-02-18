resource "aws_ssm_parameter" "endpoint" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/elasticache/${var.engine}/${var.env}-${var.name}/ENDPOINT"
  description = "Elasticache Redis Endpoint"
  type        = "String"
  value       = aws_elasticache_replication_group.default[0].cluster_enabled ? aws_elasticache_replication_group.default[0].configuration_endpoint_address : aws_elasticache_replication_group.default[0].primary_endpoint_address
}

resource "aws_ssm_parameter" "port" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/elasticache/${var.engine}/${var.env}-${var.name}/PORT"
  description = "Elasticache Redis Port"
  type        = "String"
  value       = aws_elasticache_replication_group.default[0].port
}
