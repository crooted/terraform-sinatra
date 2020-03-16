resource "aws_instance" "simple-sinatra" {
  ami                    = "${var.simple_sinatra_instance["ami"]}"
  instance_type          = "${var.simple_sinatra_instance["type"]}"
  key_name               = "${var.simple_sinatra_instance["key_name"]}"
  security_groups = [
    "${aws_security_group.sinatra-server.id}"
  ]
  subnet_id              = "${module.vpc.private_subnets[0]}"
  disable_api_termination    = "true"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.simple_sinatra_instance["root_vol"]}"
  }

  volume_tags = {
    Name = "simple-sinatra-root-vol"
  }

  tags {
    Name                 = "simple-sinatra"
    Environment          = "local"
  }
}