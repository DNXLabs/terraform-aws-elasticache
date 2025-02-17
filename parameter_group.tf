resource "aws_elasticache_parameter_group" "parameter_group" {
  name        = replace(format("%.255s", lower(replace("tf-elasticache-${var.name}-${var.env}-${var.vpc_id}-${random_id.salt.hex}", "_", "-"))), "/\\s/", "-")
  description = "Terraform-managed ElastiCache parameter group for ${var.name}-${var.env}-${var.vpc_id}"

  # Strip the patch version from redis_version var
  # family = "redis${replace(var.redis_version, "/\\.[\\d]+$/", "")}"
  family = local.major_version >= 7 ? "redis${local.major_version}" : (local.major_version == 6 ? "redis${local.major_version}.x" : "redis${replace(var.redis_version, "/\\.[\\d]+$/", "")}")
  dynamic "parameter" {
    for_each = var.redis_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
