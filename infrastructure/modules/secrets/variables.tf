variable "namespace" {
  description = "The namespace where app is created"
  type        = string
  default     = "dev"
}

variable "secrets_name" {
  description = "The namespace where app is created"
  type        = string
  default     = "mysql-secrets"
}

variable "mysql_master_password" {
  description = "The password for the mysql master instance"
  type        = string
}

variable "mysql_replication_password" {
  description = "The password for the mysql replica instance"
  type        = string
}
