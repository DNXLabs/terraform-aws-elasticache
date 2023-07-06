data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  dynamic "filter" {
    for_each = var.subnet_tags_filter
    iterator = tag
    content {
      name   = tag.key
      values = [tag.value]
    }
  }
}
