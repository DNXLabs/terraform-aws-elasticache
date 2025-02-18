resource "aws_security_group" "default" {
  name        = format("%.255s", "tf-sg-ec-${var.name}-${var.env}-${var.vpc_id}")
  description = "Terraform-managed ElastiCache security group for ${var.name}-${var.env}-${var.vpc_id}"
  vpc_id      = var.vpc_id

  tags = {
    Name = "tf-sg-ec-${var.name}-${var.env}-${var.vpc_id}"
  }
}

resource "aws_security_group_rule" "inbound_from_sg" {
  for_each                 = { for security_group_id in var.allow_security_group_ids : security_group_id.name => security_group_id }
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = each.value.security_group_id
  security_group_id        = aws_security_group.default.id
  description              = try(each.value.description, "From ${each.value.security_group_id}")
}

resource "aws_security_group_rule" "networks_ingress" {
  for_each          = { for cidr in var.allowed_cidr : cidr.name => cidr }
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = [each.value.cidr]
  security_group_id = aws_security_group.default.id
  description       = try(each.value.description, "From ${each.value.cidr}")
}
