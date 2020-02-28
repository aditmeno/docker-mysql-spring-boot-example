variable "prod_namespace" {
  description = "The name for the so1-java app production namespace"
  type        = string
  default     = "prod"
}

variable "dev_namespace" {
  description = "The name for the so1-java app development namespace"
  type        = string
  default     = "dev"
}

variable "qa_namespace" {
  description = "The name for the so1-java app QA namespace"
  type        = string
  default     = "qa"
}
