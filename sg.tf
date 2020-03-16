resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "Access control for elb"
  vpc_id      =  "${module.vpc.public_subnets[0]}"

  ingress {
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "sinatra-server" {
  name        = "sinatra-server"
  description = "sinatra Server access controls"
  vpc_id      =  "${module.vpc.private_subnets[0]}"
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${module.vpc.public_subnet_cidrs}","${module.vpc.private_subnet_cidrs}"]
  }
}
