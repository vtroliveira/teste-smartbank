resource "aws_security_group" "cache" {
    name = "cache-sg"
    description = "Allow access to redis cache"

    ingress {
        from_port = "${lookup(var.cache, "port")}"
        to_port = "${lookup(var.cache, "port")}"
        protocol = "tcp"
        security_groups = ["${aws_security_group.smartbank-web-app-sg.id}"]
    }

    egress {
        from_port = "${lookup(var.cache, "port")}"
        to_port = "${lookup(var.cache, "port")}"
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    vpc_id = "${aws_vpc.smartbank.id}"

    tags {
        Name = "smartbank-cache-sg"
        Ambiente = "Teste-Prático"
    }
}

resource "aws_elasticache_subnet_group" "cache-subnet-group" {
  name       = "smartbank-cache-subnet-group"
  subnet_ids = ["${aws_subnet.private_subnet_1.id}", "${aws_subnet.private_subnet_2.id}"]
}

resource "aws_elasticache_cluster" "smartbank-cache" {
  cluster_id            = "smartbank-redis"
  engine                = "${lookup(var.cache, "engine")}"
  node_type             = "${lookup(var.cache, "type")}"
  num_cache_nodes       = "${lookup(var.cache, "nodes")}"
  port                  = "${lookup(var.cache, "port")}"
  subnet_group_name     = "${aws_elasticache_subnet_group.cache-subnet-group.name}"
  security_group_ids    = ["${aws_security_group.cache.id}"]
}