resource "aws_security_group" "database" {
    name = "database-sg"
    description = "Allow access to database"

    ingress {
        from_port = "${lookup(var.database, "port")}"
        to_port = "${lookup(var.database, "port")}"
        protocol = "tcp"
        security_groups = ["${aws_security_group.smartbank-web-app-sg.id}"]
    }

    egress {
        from_port = "${lookup(var.database, "port")}"
        to_port = "${lookup(var.database, "port")}"
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    vpc_id = "${aws_vpc.smartbank.id}"

    tags {
        Name = "smartbank-database-sg"
        Ambiente = "Teste-Prático"
    }
}

resource "aws_db_subnet_group" "database-subnet" {
  name       = "smartbank-database-subnet"
  subnet_ids = ["${aws_subnet.private_subnet_1.id}", "${aws_subnet.private_subnet_2.id}"]

  tags = {
    Name = "smartbank-database-subnet"
  }
}

resource "aws_db_instance" "smartbank-postgres" {
  identifier                = "smartbank-postgres-db"
  db_subnet_group_name      = "${aws_db_subnet_group.database-subnet.name}"
  vpc_security_group_ids    = ["${aws_security_group.database.id}"]
  final_snapshot_identifier = "${lookup(var.database, "snapshot_name")}-${uuid()}"
  allocated_storage         = "${lookup(var.database, "storage")}"
  storage_type              = "${lookup(var.database, "storage_type")}"
  engine                    = "${lookup(var.database, "engine")}"
  engine_version            = "${lookup(var.database, "version")}"
  instance_class            = "${lookup(var.database, "type")}"
  name                      = "${lookup(var.database, "dbname")}"
  username                  = "${lookup(var.database, "usr")}"
  password                  = "${lookup(var.database, "pwd")}"
  port                      = "${lookup(var.database, "port")}"
}