output "redis_security_group_id" {
  value = aws_security_group.redis_security_group.id
}

output "parameter_group" {
  value = aws_elasticache_parameter_group.redis_parameter_group.id
}

output "redis_subnet_group_name" {
  value = var.create_redis_subnet_group == true ? aws_elasticache_subnet_group.redis_subnet_group[0].name : ""
}

output "id" {
  value = aws_elasticache_replication_group.redis.id
}

output "port" {
  value = var.redis_port
}

output "endpoint" {
  value = var.redis_cluster_enable == true ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.primary_endpoint_address
}
