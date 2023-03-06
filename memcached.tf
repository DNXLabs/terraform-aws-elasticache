resource "aws_elasticache_cluster" "memcached" {
  count                  = var.engine_type == "memcached" ? 1 : 0
  cluster_id           = var.name
  engine               = "memcached"
  node_type            = var.memcached_node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = aws_elasticache_parameter_group.memcached_parameter_group.id
  port                 = var.memcached_port
}

resource "aws_elasticache_parameter_group" "memcached_parameter_group" {
  count = var.engine_type == "memcached" ? 1 : 0
  name  = replace(format("%.255s", lower(replace("tf-memcached-${var.name}-${var.env}-${var.vpc_id}-${random_id.salt.hex}", "_", "-"))), "/\\s/", "-")

  description = "Terraform-managed ElastiCache parameter group for ${var.name}-${var.env}-${var.vpc_id}"

  # Strip the patch version from redis_version var
  family = "memcached${replace(var.redis_version, "/\\.[\\d]+$/", "")}"
  dynamic "parameter" {
    for_each = var.memcached_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}