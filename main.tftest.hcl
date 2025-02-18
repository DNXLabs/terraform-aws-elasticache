provider "aws" {
  region = "ap-southeast-2"
}

run "can_create_redis_replication_group" {
  command = plan
  variables {
    engine = "redis"
    name   = "test-redis"
    vpc_id = "vpc-0595a656728f6cb4e"
    env    = "test"
  }
}

run "can_create_valkey_replication_group" {
  command = plan
  variables {
    engine = "valkey"
    name   = "test-valkey"
    vpc_id = "vpc-0595a656728f6cb4e"
    env    = "test"
  }
}

run "can_create_redis_replication_group_with_custom_parameters" {
  command = plan
  variables {
    engine = "redis"
    name   = "test-redis"
    vpc_id = "vpc-0595a656728f6cb4e"
    env    = "test"
    redis_parameters = [
      {
        name  = "hash-max-ziplist-entries"
        value = "512"
      },
      {
        name  = "hash-max-ziplist-value"
        value = "64"
      },
    ]
  }
}

run "can_" {

}
