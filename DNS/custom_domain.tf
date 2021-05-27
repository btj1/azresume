resource "aws_route53_record" "az-resume" {
  zone_id = var.hosted_zone_id
  name    = var.custom_domain
  type    = "CNAME"
  ttl     = "5"
 
  records        = [var.cdn_endpoint]
}