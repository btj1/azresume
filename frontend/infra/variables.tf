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

variable "cdn_profile" {
  type        = string
  description = "CDN Profile name"
}

variable "cdn_endpoint_name" {
  type        = string
  description = "CDN Endpoint name"
}

variable "custom_domain" {
  type        = string
  description = "Domain the Website is reachable on"
}

