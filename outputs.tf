output "security_group_id" {
  value = aws_security_group.redis_security_group.id
}

output "parameter_group" {
  value = var.engine_type == "redis" ? aws_elasticache_parameter_group.redis_parameter_group.id : aws_elasticache_parameter_group.memcached_parameter_group.id
}

output "redis_subnet_group_name" {
  count = var.engine_type == "redis"
  value = aws_elasticache_subnet_group.redis_subnet_group.name
}

output "id" {
  count = var.engine_type == "redis"
  value = aws_elasticache_replication_group.redis.id
}

output "port" {
  value = var.engine_type == "redis" ? var.redis_port : var.memcached_port
}

output "endpoint" {
  value = var.engine_type == "redis" ?  var.redis_cluster_enable == true ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.primary_endpoint_address : aws_elasticache_cluster.memcached.cluster_address
}
