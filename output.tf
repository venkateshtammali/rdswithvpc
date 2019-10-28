output "rds" {
  value = "${aws_db_instance.postgres.endpoint}"
}
