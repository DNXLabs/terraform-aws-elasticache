# A Terraform module to create a Redis ElastiCache cluster

A terraform module providing a Redis ElastiCache cluster in AWS.

This module

- Creates Redis ElastiCache clusters
- Creates, manages, and exports a security group

## Terraform versions

Terraform 0.12. Pin module version to `~> v2.0`. Submit pull-requests to `master` branch.

Terraform 0.11. Pin module version to `~> v1.0`. Submit pull-requests to `terraform011` branch.

## Usage

```hcl
module "redis" {
  source = "git::https://github.com/DNXLabs/terraform-aws-elasticache.git?ref=0.3.1"
  for_each                = { for redis in try(local.workspace.elasticache.redis, []) : redis.name => redis }
  env                     = each.value.env
  name                    = each.value.name
  redis_node_type         = each.value.redis_node_type # Required
  redis_clusters          = try(each.value.redis_clusters, 0) # "Number of Redis cache clusters (NODES) to create"
  multi_az_enabled        = try(each.value.multi_az_enabled, false) # For "multi_az_enabled" also need to enable "redis_failover" and update "redis_clusters" to at least 2 nodes
  redis_failover          = try(each.value.redis_failover, false)
  allowed_cidr            = try(each.value.allowed_cidr, ["127.0.0.1/32"]) # "A list of Security Group ID's to allow access to."
  allowed_security_groups = try(each.value.allowed_security_groups, [])    # "A list of Security Group ID's to allow access to."
  security_group_names    = try(each.value.security_group_names, [])       # Can't be used with "allowed_security_groups" (SG_ID with SG_Name)

  vpc_id                         = data.aws_vpc.selected[0].id
  redis_maintenance_window       = try(each.value.redis_maintenance_window, "") # The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period"
  redis_port                     = try(each.value.redis_port, 6379)
  redis_snapshot_retention_limit = try(each.value.redis_snapshot_retention_limit, 0)
  redis_snapshot_window          = try(each.value.redis_snapshot_window, "06:30-07:30") # "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  redis_version                  = try(each.value.redis_version, "3.2.10")              # "Whether to enable encryption in transit. Requires 3.2.6 or >=4.0 redis_version"
  snapshot_arns                  = try(each.value.snapshot_arns, [])                    # "A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb"
  snapshot_name                  = try(each.value.snapshot_name, "")                    # " The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource"
  tags                           = try(each.value.tags, {})
  transit_encryption_enabled     = try(each.value.transit_encryption_enabled, false)
  redis_parameters               = try(each.value.redis_parameters, [])
  apply_immediately              = try(each.value.apply_immediately, false) # "Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false."
  at_rest_encryption_enabled     = try(each.value.at_rest_encryption_enabled, false)
  auth_token                     = try(each.value.auth_token, null)                  # "The password used to access a password protected server. Can be specified only if transit_encryption_enabled = true. If specified must contain from 16 to 128 alphanumeric characters or symbols"
  auto_minor_version_upgrade     = try(each.value.auto_minor_version_upgrade, false) # "Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window"
  availability_zones             = try(each.value.availability_zones, [])
  kms_key_id                     = try(each.value.kms_key_id, "")
  notification_topic_arn         = try(each.value.notification_topic_arn, "")

}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_cidr | A list CIDRs to allow access to. | `list(string)` | <pre>[<br>  "127.0.0.1/32"<br>]</pre> | no |
| allowed\_security\_groups | A list of Security Group ID's to allow access to. | `list(string)` | `[]` | no |
| apply\_immediately | Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false. | `bool` | `false` | no |
| at\_rest\_encryption\_enabled | Whether to enable encryption at rest | `bool` | `false` | no |
| auth\_token | The password used to access a password protected server. Can be specified only if transit\_encryption\_enabled = true. If specified must contain from 16 to 128 alphanumeric characters or symbols | `string` | `null` | no |
| auto\_minor\_version\_upgrade | Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window | `bool` | `true` | no |
| availability\_zones | A list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is not important | `list(string)` | `[]` | no |
| env | env to deploy into, should typically dev/staging/prod | `string` | n/a | yes |
| kms\_key\_id | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at\_rest\_encryption\_enabled = true | `string` | `""` | no |
| name | Name for the Redis replication group i.e. UserObject | `string` | n/a | yes |
| notification\_topic\_arn | An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to. Example: arn:aws:sns:us-east-1:012345678999:my\_sns\_topic | `string` | `""` | no |
| redis\_clusters | Number of Redis cache clusters (nodes) to create | `string` | n/a | yes |
| redis\_failover | n/a | `bool` | `false` | no |
| redis\_maintenance\_window | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period | `string` | `"fri:08:00-fri:09:00"` | no |
| redis\_node\_type | Instance type to use for creating the Redis cache clusters | `string` | `"cache.m3.medium"` | no |
| redis\_parameters | additional parameters modifyed in parameter group | `list(map(any))` | `[]` | no |
| redis\_port | n/a | `number` | `6379` | no |
| redis\_snapshot\_retention\_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro or cache.t2.\* cache nodes | `number` | `0` | no |
| redis\_snapshot\_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period | `string` | `"06:30-07:30"` | no |
| redis\_version | Redis version to use, defaults to 3.2.10 | `string` | `"3.2.10"` | no |
| security\_group\_names | A list of cache security group names to associate with this replication group | `list(string)` | `[]` | no |
| snapshot\_arns | A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my\_bucket/snapshot1.rdb | `list(string)` | `[]` | no |
| snapshot\_name | The name of a snapshot from which to restore data into the new node group. Changing the snapshot\_name forces a new resource | `string` | `""` | no |
| subnets | List of VPC Subnet IDs for the cache subnet group | `list(string)` | n/a | yes |
| tags | Tags for redis nodes | `map(string)` | `{}` | no |
| transit\_encryption\_enabled | Whether to enable encryption in transit. Requires 3.2.6 or >=4.0 redis\_version | `bool` | `false` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| endpoint | n/a |
| id | n/a |
| parameter\_group | n/a |
| port | n/a |
| redis\_security\_group\_id | n/a |
| redis\_subnet\_group\_name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).
## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-template/blob/master/LICENSE) for full details.
