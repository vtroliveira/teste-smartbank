resource "aws_route53_zone" "smartbank-public-zone" {
  name = "testepratico.net.br"
}

resource "aws_route53_record" "smartbank-web-app-dns" {
  zone_id = "${aws_route53_zone.smartbank-public-zone.zone_id}"
  name    = "web"
  type    = "CNAME"
  ttl     = "30"

  records = [
    "${aws_lb.smartbank-web-app-elb.dns_name}"
  ]
}

resource "aws_route53_record" "smartbank-databse-dns" {
  zone_id = "${aws_route53_zone.smartbank-public-zone.zone_id}"
  name    = "database"
  type    = "CNAME"
  ttl     = "30"

  records = [
    "${aws_db_instance.smartbank-postgres.endpoint}"
  ]
}

resource "aws_route53_record" "smartbank-cache-dns" {
  zone_id = "${aws_route53_zone.smartbank-public-zone.zone_id}"
  name    = "cache"
  type    = "CNAME"
  ttl     = "30"

  records = [
    "${aws_elasticache_cluster.smartbank-cache.cache_nodes.0.address}"
  ]
}