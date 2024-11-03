#RDS Database Credentials

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  sensitive   = true
}

variable "terraform_remote_state" {
  description = "Terraform remote s3 state ucket Name"
  type        = string
  sensitive   = true
}