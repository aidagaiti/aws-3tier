resource "aws_route53_record" "wordpress" {
  zone_id = "Z0680016PA4LTHI66LBC"
  name    = "wordpress.${var.domain-name}"
  type    = "CNAME"
 

 alias {
    name                   = "${aws_lb.external-alb.dns_name}"
    zone_id                = "${aws_lb.external-alb.zone_id}"
    evaluate_target_health = true
  }
}