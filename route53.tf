resource "aws_route53_record" "wordpress" {
  zone_id = var.hosted-zone-id
  name    = "wordpress.${var.domain-name}"
  type    = "CNAME"
  ttl = "300"
  records = [aws_lb.external-alb.dns_name]
}
