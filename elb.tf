resource "aws_elb" "simple-sinatra" {
  name               = "simple-sinatra"
  subnets            = ["${module.vpc.public_subnets[0]}"]
  internal           = false

  instances           = ["${aws_instance.simple-sinatra.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    target              = "HTTP:80/"
    interval            = 5
  }

  security_groups             = ["${aws_security_group.elb_sg.id}"]

  cross_zone_load_balancing   = false
  idle_timeout                = 400

  tags = "${merge(
    map("Name", "simple-sinatra-elb")
    )
  }"

}
