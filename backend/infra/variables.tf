variable "location" {
  type        = string
  description = "The location the website is deployed to"
}

variable "location_short_code" {
  type        = string
  description = "The location short code for the location the website is deployed to"
}

variable "projectname" {
  type        = string
  description = "The name of this project"
}

variable "appversion" {
  type        = string
  description = " Version"

}
variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "db_container" {
  type        = string
  description = "DB Container für the counter table"
}

variable "db_name" {
  type        = string
  description = "DB Name für the counter table"
}

variable "func_source" {
  type        = string
  description = "Source path to AZ Func files"
}
