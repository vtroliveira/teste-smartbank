resource "aws_security_group" "smartbank-alb-sg" {
    name = "smartbank-alb-sg"
    description = "Allow HTTP requests"

    ingress {
        from_port       = "${lookup(var.web_application, "elb_port")}"
        to_port         = "${lookup(var.web_application, "elb_port")}"
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = "${lookup(var.web_application, "elb_port")}"
        to_port         = "${lookup(var.web_application, "elb_port")}"
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.smartbank.id}"

    tags {
        Name = "smartbank-smartbank-alb-sg"
        Ambiente = "Teste-Prático"
    }
}

resource "aws_security_group" "smartbank-web-app-sg" {
    name = "smartbank-web-app-sg"
    description = "Allow HTTP requests"

    ingress {
        from_port       = "${lookup(var.web_application, "port")}"
        to_port         = "${lookup(var.web_application, "port")}"
        protocol        = "tcp"
        security_groups = ["${aws_security_group.smartbank-alb-sg.id}"]
    }

    egress {
        from_port       = "${lookup(var.web_application, "port")}"
        to_port         = "${lookup(var.web_application, "port")}"
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.smartbank.id}"

    tags {
        Name = "smartbank-smartbank-web-app-sg"
        Ambiente = "Teste-Prático"
    }
}

resource "aws_instance" "smartbank-web-app-1" {
    ami                             = "${var.ami_id}"
    availability_zone               = "${var.aws_region}a"
    instance_type                   = "${var.web_app_instance_type}"
    key_name                        = "${var.aws_key_name}"
    vpc_security_group_ids          = ["${aws_security_group.smartbank-web-app-sg.id}"]
    subnet_id                       = "${aws_subnet.public_subnet_1.id}"
    associate_public_ip_address     = true
    source_dest_check               = false

    tags {
        Name = "smartbank-web-app"
        Ambiente = "Teste-Prático"
    }
}

resource "aws_lb" "smartbank-web-app-elb" {
  name               = "smartbank-web-app-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.smartbank-alb-sg.id}", "${aws_security_group.smartbank-web-app-sg.id}"]
  subnets            = ["${aws_subnet.public_subnet_1.id}", "${aws_subnet.public_subnet_2.id}"]

  enable_deletion_protection = false

  tags = {
    Ambiente = "Teste-Prático"
  }
}

resource "aws_lb_target_group" "smartbank-web-app-tg" {
  name     = "smartbank-web-app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.smartbank.id}"

  health_check {
      path                  = "/"
      matcher               = "200"
      unhealthy_threshold   = 10
  }
}

resource "aws_lb_target_group_attachment" "smartbank-web-app-tg-association" {
  target_group_arn = "${aws_lb_target_group.smartbank-web-app-tg.arn}"
  target_id        = "${aws_instance.smartbank-web-app-1.id}"
  port             = 8080
}

resource "aws_lb_listener" "smartbank-web-app-listener" {
  load_balancer_arn = "${aws_lb.smartbank-web-app-elb.arn}"
  port              = "9090"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.smartbank-web-app-tg.arn}"
  }
}