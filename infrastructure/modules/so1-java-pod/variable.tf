variable "namespace" {
  description = "The namespace where app is created"
  type        = string
  default     = "dev"
}

variable "deploy_name" {
  description = "The name where app deployment"
  type        = string
  default     = "so1-java-app-deploy"
}

variable "so1_java_service_name" {
  description = "The name for the so1-java-app service"
  type        = string
  default     = "so1-java-app"
}

variable "container_image" {
  description = "The container image used for the app"
  type        = string
  default     = "rezesius/so1-java-app"
}

variable "image_version_tag" {
  description = "The container image version to be used"
  type        = string
  default     = "v1"
}


variable "mysql_host" {
  description = "The jdbc url for mysql"
  type        = string
  default     = "jdbc:mysql://mysql-master.dev/test"
}

variable "port" {
  description = "The port exposed by service"
  type        = number
  default     = 8086
}
