data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "selected" {
  dynamic "filter" {
    for_each = var.subnet_tags_filter
    iterator = tag
    content {
      name   = tag.key
      values = [tag.value]
    }
  }
}
