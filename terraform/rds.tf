resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "MainDBSubnetGroup"
  }
}

resource "aws_db_instance" "main" {
  identifier              = "event-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "eventdb"
  username                = var.db_user
  password                = var.db_pass
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [var.db_security_group_id]
  skip_final_snapshot     = true
  publicly_accessible     = false

  tags = {
    Name = "EventDrivenDB"
  }
}

