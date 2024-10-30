output "instance_msr_public_ip" {
  description = "Public IP for Instance  "
  value = aws_instance.first.public_ip
}

output "instance_msr_public_ip2" {
  description = "Public IP for Instance 2 "
  value = aws_instance.first1.public_ip
}

output "aws_db_instance" {
    description = "Endpoint for MySQL RDS instance"
    value = aws_db_instance.mysql_rds.endpoint
}

output "load_balancer_dns" {
  description = "DNS name for Application Load Balancer"
  value = aws_lb.app_lb.dns_name
}

  