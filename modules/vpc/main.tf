resource "aws_vpc" "vpc" {
  cidr_block = "${var.subnet}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = "${merge(var.vpc_tags, map("Name","${var.name}") )}"
}

resource "aws_internet_gateway" "internet" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.name}-internet-gateway"
  }
}

# Add VPC Flow Logs

# Create s3 bucket to store logs with lifecycle rules
resource "aws_s3_bucket" "flow_logs_bucket" {
  count  = "${var.enable_flow_logs == "true" ? 1 : 0}"
  bucket = "${var.name}-flow-logs"
  acl = "private"

  lifecycle_rule {
    enabled = true

    transition {
      days = "${var.days_to_transition_to_ia}"
      storage_class = "STANDARD_IA"
    }
  }
}

resource "aws_subnet" "public_subnet" {
    count = "${length(var.availability_zones)}"

    vpc_id                  = "${aws_vpc.vpc.id}"
    cidr_block              = "${cidrsubnet(var.subnet, var.subnet_address_bits, var.public_subnets_address_offset + count.index)}"
    availability_zone       = "${element(var.availability_zones, count.index)}"

    tags = "${merge(var.public_subnet_tags, map( "Name", "${var.name}-public-subnet-${count.index}"))}"
}

resource "aws_subnet" "private_subnet" {
    count = "${length(var.availability_zones)}"

    vpc_id            = "${aws_vpc.vpc.id}"
    cidr_block        = "${cidrsubnet(var.subnet, var.subnet_address_bits, var.private_subnets_address_offset + count.index)}"
    availability_zone = "${element(var.availability_zones, count.index)}"

    tags = "${merge(var.private_subnet_tags, map( "Name", "${var.name}-private-subnet-${count.index}"))}"

}

resource "aws_route_table" "default_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name   = "${var.name}-default-route-table"
  }
}

resource "aws_route" "public_default" {
  route_table_id            = "${element(aws_route_table.default_route_table.*.id, count.index)}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet.id}"
}

resource "aws_eip" "nat_gateway" {
    vpc   = true

    lifecycle {
        prevent_destroy = false
    }
}

resource "aws_nat_gateway" "internet" {
  allocation_id = "${aws_eip.nat_gateway.id}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, 0)}"
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name   = "${var.name}-private-route-table"
  }
}

resource "aws_route" "private_default" {
  route_table_id            = "${element(aws_route_table.private_route_table.*.id, count.index)}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.internet.id}"
}

resource "aws_route_table_association" "public_subnet" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.default_route_table.id}"
}

resource "aws_route_table_association" "private_subnet" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}
