variable "mysql_master_password" {
  description = "The password for the mysql master instance"
  type        = string
  default     = "password"
}

variable "mysql_replication_password" {
  description = "The password for the mysql replica instance"
  type        = string
  default     = "demo"
}
