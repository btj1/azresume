variable "aws_region" {
  type        = string
  description = "The region for this AWS stack"
}

variable "custom_domain" {
  type        = string
  description = "The domain to use for the CNAME entry"
}

variable "cdn_endpoint" {
  type        = string
  description = "The name of the cdn endpoint"
}

variable "hosted_zone_id" {
  type        = string
  description = "ID for the Hosted Zone this record will be created in"
}
