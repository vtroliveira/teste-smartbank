variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_name" {}
variable "ami_id" {}

variable "web_app_instance_type" {
  default = "m1.small"
}

variable "aws_region" {
    default = "us-east-1"
}

variable "vpc_cidr" {
    description = "CIDR para VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
    description = "CIDR para o subnet público"
    default = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
    description = "CIDR para o subnet público"
    default = "10.0.2.0/24"
}

variable "private_subnet_cidr_1" {
    description = "CIDR para o subnet privado"
    default = "10.0.3.0/24"
}

variable "private_subnet_cidr_2" {
    description = "CIDR para o subnet privado"
    default = "10.0.4.0/24"
}

variable "database" {
    description = "Configurações da instância rds"
    default = {
        storage = 10
        storage_type = "gp2"
        engine = "postgres"
        version = "9.6.3"
        type = "db.t2.micro"
        dbname = "demodb"
        usr = "demouser"
        pwd = "YourPwdShouldBeLongAndSecure!"
        port = "5432"
        snapshot_name = "smartbank-postgres-db-snapshot"
    }
}

variable "cache" {
    description = "Configurações da instância elasticsearch redis"
    default = {
        engine  = "redis"
        type    = "cache.m4.large"
        port    = 6379
        nodes   = 1  
    }
}

variable "web_application" {
    description = "Configurações da aplicação web"
    default = {
        port        = 8080
        elb_port    = 9090
    }
}
