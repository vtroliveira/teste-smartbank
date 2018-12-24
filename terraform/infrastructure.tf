resource "aws_vpc" "smartbank" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "smartbank-vpc"
    }
}

resource "aws_internet_gateway" "smartbank_ig" {
    vpc_id = "${aws_vpc.smartbank.id}"

    tags {
        Name = "smartbank-internet-gateway"
    }
}

resource "tls_private_key" "public_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "smartbank_key" {
  key_name   = "${var.aws_key_name}"
  public_key = "${tls_private_key.public_key.public_key_openssh}"
}

resource "aws_subnet" "public_subnet_1" {
    vpc_id = "${aws_vpc.smartbank.id}"

    cidr_block = "${var.public_subnet_cidr_1}"
    availability_zone = "${var.aws_region}a"

    tags {
        Name = "smartbank-public-subnet-1"
    }
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = "${aws_vpc.smartbank.id}"

    cidr_block = "${var.public_subnet_cidr_2}"
    availability_zone = "${var.aws_region}d"

    tags {
        Name = "smartbank-public-subnet-2"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = "${aws_vpc.smartbank.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.smartbank_ig.id}"
    }

    tags {
        Name = "smartbank-public-route-table"
    }
}

resource "aws_route_table_association" "public_rt_association_1" {
    subnet_id = "${aws_subnet.public_subnet_1.id}"
    route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "public_rt_association_2" {
    subnet_id = "${aws_subnet.public_subnet_2.id}"
    route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_subnet" "private_subnet_1" {
    vpc_id = "${aws_vpc.smartbank.id}"

    cidr_block = "${var.private_subnet_cidr_1}"
    availability_zone = "${var.aws_region}a"

    tags {
        Name = "smartbank-private-subnet-1"
    }
}

resource "aws_subnet" "private_subnet_2" {
    vpc_id = "${aws_vpc.smartbank.id}"

    cidr_block = "${var.private_subnet_cidr_2}"
    availability_zone = "${var.aws_region}b"

    tags {
        Name = "smartbank-private-subnet-2"
    }
}