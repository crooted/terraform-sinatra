output "public_subnets" {
  value = "${concat(aws_subnet.public_subnet.*.id, list())}"
}

output "public_subnet_cidrs" {
  value = "${concat(aws_subnet.public_subnet.*.cidr_block, list())}"
}

output "private_subnets" {
  value = "${concat(aws_subnet.private_subnet.*.id, list())}"
}

output "private_subnet_cidrs" {
  value = "${concat(aws_subnet.private_subnet.*.cidr_block, list())}"
}