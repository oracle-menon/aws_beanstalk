module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "interview-project-database"

  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "InterviewProjectDatabase"
  username = "interviewMaster"
  port     = "5432"

  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [aws_security_group.interview_project_rds_sg.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"


  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.database_subnets
  multi_az               = true

  # DB parameter group
  family = "postgres16"

  # DB option group
  major_engine_version = "16"

  # Database Deletion Protection
  deletion_protection = false

  tags = {
    Terraform = "true"
  }
}

# Security group for the database
resource "aws_security_group" "interview_project_rds_sg" {
  name        = "interview-project-rds-sg"
  description = "Allow TLS inbound traffic and all outbound traffic for the database"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Terraform = "true"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_traffic_from_application" {
  security_group_id            = aws_security_group.interview_project_rds_sg.id
  referenced_security_group_id = aws_security_group.interview_project_application_sg.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.interview_project_rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.interview_project_rds_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}