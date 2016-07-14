output "vpc_id" {
    value = "${aws_vpc.vpc.id}"
}


output "public-route-igw-id" {
    value = "${join(",", aws_subnet.public-route-igw.*.id)}"
}

output "public-route-variable-id" {
    value = "${join(",", aws_subnet.public-route-variable.*.id)}"
}

output "protected-route-nat-id" {
    value = "${join(",", aws_subnet.protected-route-nat.*.id)}"
}

output "private-route-local-id" {
    value = "${join(",", aws_subnet.private-route-local.*.id)}"
}


output "public-route-igw-table-id" {
    value = "${aws_route_table.public-route-igw-table.id}"
}

output "public-route-variable-table-id" {
    value = "${aws_route_table.public-route-variable-table.id}"
}

output "protected-route-nat-table-id" {
    value = "${aws_route_table.protected-route-nat-table.id}"
}

output "private-route-local-table-id" {
    value = "${aws_route_table.private-route-local-table.id}"
}
