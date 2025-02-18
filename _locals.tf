locals {
  major_version = tonumber(replace(var.engine_version, "/\\.[\\d][\\.\\d]*/", ""))
}
