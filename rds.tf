# main.tf
terraform {
  required_version = "~> 0.12.0"

  backend "remote" {}
}
provider "aws" {
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
    region = "${var.AWS_REGION}"
}
resource "aws_db_subnet_group" "postgres-subnet" {
    name = "postgres-subnet"
    description = "RDS subnet group"
    subnet_ids = ["${aws_subnet.main-public-1.id}","${aws_subnet.main-public-2.id}"]
}
resource "aws_db_instance" "postgres" {
  allocated_storage    = 20    
  engine               = "postgres"
  engine_version       = "11.5"
  instance_class       = "db.t2.micro"    
  identifier           = "aptyrds"
  name                 = "aptyrds"
  username             = "root"   
  password             = "${var.RDS_PASSWORD}"
  db_subnet_group_name = "${aws_db_subnet_group.postgres-subnet.name}"
  port                 = 5432
  publicly_accessible  = true
  multi_az             = "false"
  vpc_security_group_ids = ["${aws_security_group.allow-postgres.id}"]
  availability_zone = "${aws_subnet.main-public-1.availability_zone}"
  storage_type         = "gp2"
  tags = {
      Name = "postgres-instance"
  }
}
