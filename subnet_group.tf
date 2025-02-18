resource "aws_elasticache_subnet_group" "default" {
  count      = var.create_subnet_group ? 1 : 0
  name       = replace(format("%.255s", lower(replace("tf-elasticache-${var.name}-${var.env}-${var.vpc_id}", "_", "-"))), "/\\s/", "-")
  subnet_ids = data.aws_subnets.selected.ids
}
