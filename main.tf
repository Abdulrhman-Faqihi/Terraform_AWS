provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

#Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "myvpc"
  }
}

#Create Subnet 1 , 2
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Faqehi_Subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Faqehi_Subnet_2"
  }
}
#Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Faqehi_Internet"
  }
}
#Create Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Faqehi_route"
  }
}

#Connect Route table with subnet 1 and 2
resource "aws_route_table_association" "rta_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "rta_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.route_table.id
}

#Create Security group
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Faqehi_security"
  }
}

# Create Load Balancer
resource "aws_lb" "app_lb" {
  name               = "FF123123"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "F_Load_Balancer"
  }
  
  depends_on = [
    aws_instance.first,
    aws_instance.first1
  
    ]
}

# Create Target Group
resource "aws_lb_target_group" "app_lb_target" {
  name     = "FaqehiAppTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

    depends_on = [
    aws_instance.first,
    aws_instance.first1,
    aws_lb.app_lb
  
    ]
}

#Connect Target Group with EC2 Instance 1 and 2
resource "aws_lb_target_group_attachment" "app_lb_attachment_1" {
  target_group_arn = aws_lb_target_group.app_lb_target.arn
  target_id        = aws_instance.first.id
  port             = 80

    depends_on = [
    aws_instance.first,
    aws_instance.first1
    
        ]
}

resource "aws_lb_target_group_attachment" "app_lb_attachment_2" {
  target_group_arn = aws_lb_target_group.app_lb_target.arn
  target_id        = aws_instance.first1.id
  port             = 80

   depends_on = [
    aws_instance.first,
    aws_instance.first1
    
        ]
}

################################
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_target.arn
  }

   depends_on = [
    aws_instance.first,
    aws_instance.first1,
    aws_lb.app_lb
    ]
}


resource "aws_instance" "first" {
  ami           = ""
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = "tes"
  security_groups = [ aws_security_group.allow_ssh.id ]
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp2"
    volume_size = "16"
    delete_on_termination = true
  }

    user_data_base64 = base64encode("${templatefile("script.sh", {

    db_endpoint = aws_db_instance.mysql_rds.endpoint
    db_pass = "Password1231"
    db_user = "admin"
    db_name = "lockers"

      }
        )

          }"
    
    )

    depends_on = [
      aws_db_instance.mysql_rds
    ]


  tags = {
    Name = "Faqehi"
  }


}

resource "aws_instance" "first1" {
  ami           = ""
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_2.id
  key_name      = "tes"
  security_groups = [ aws_security_group.allow_ssh.id ]
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp2"
    volume_size = "16"
    delete_on_termination = true
  }

    user_data_base64 = base64encode("${templatefile("script.sh", {

    db_endpoint = aws_db_instance.mysql_rds.endpoint
    db_pass = "Password1231"
    db_user = "admin"
    db_name = "lockers"

    })}")

    depends_on = [
      aws_db_instance.mysql_rds
    ]


  tags = {
    Name = "Faqehi"
  }
}

resource "aws_db_instance" "mysql_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.small"
  db_name              = "lockers"
  username             = "admin"
  password             = "Password1231"  
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  skip_final_snapshot  = true 
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "faqehi_rds_subnet_group"
  subnet_ids = [
    aws_subnet.public_subnet_1.id,  
    aws_subnet.public_subnet_2.id   
  ]
  tags = {
    Name = "Faqehi RDS Subnet Group"
  }
}

output "ec2_instance_public_ip" {
  value = aws_instance.first.public_ip

}
output "ec2_instance_public_i" {
  value = aws_instance.first1.public_ip

}


output "aws_db_instance" {
  value = aws_db_instance.mysql_rds.endpoint
}

output "load_balancer_dns" {
  value = aws_lb.app_lb.dns_name
}
