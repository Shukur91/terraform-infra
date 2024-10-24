data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "iminov"
    workspaces = {
      name = "vpc"
    }
  }
}


resource "aws_db_subnet_group" "default" {
  name       = "cloud"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.default.name
}