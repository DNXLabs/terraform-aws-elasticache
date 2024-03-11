locals {
  major_version = tonumber(replace(var.redis_version, "/\\.[\\d][\\.\\d]*/", ""))
}
