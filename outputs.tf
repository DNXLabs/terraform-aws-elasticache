output "security_group_id" {
  value = aws_security_group.security_group.id
}

output "parameter_group" {
  value = aws_elasticache_parameter_group.parameter_group.id
}

output "subnet_group_name" {
  value = var.create_subnet_group == true ? aws_elasticache_subnet_group.subnet_group[0].name : ""
}

output "id" {
  value = aws_elasticache_replication_group.default.id
}

output "port" {
  value = var.port
}

output "endpoint" {
  value = var.cluster_enabled == true ? aws_elasticache_replication_group.default.configuration_endpoint_address : aws_elasticache_replication_group.default.primary_endpoint_address
}
