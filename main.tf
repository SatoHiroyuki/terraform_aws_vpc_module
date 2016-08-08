##################
# VPC
##################

resource "aws_vpc" "vpc" {
    cidr_block = "${var.ip_address}"
    enable_dns_hostnames = "${var.dns_hostnames}"
    tags {
        Name = "${var.vpc_name}"
    }
}

##################
# VPC Subnet
##################

resource "aws_subnet" "public-route-igw" {
    count = "${length(compact(split(",", var.public-route-igw)))}"
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.ip_address_network_portion}${element(split(",", var.public-route-igw), count.index)}"
    availability_zone = "${element(split(",", var.availability_zone), count.index)}"
    map_public_ip_on_launch = true
    tags {
        Name = "${element(split(",", var.environment), count.index)}-public-route-igw-${element(split(",", var.availability_zone), count.index)}"
    }
}

resource "aws_subnet" "public-route-variable" {
    count = "${length(compact(split(",", var.public-route-variable)))}"
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.ip_address_network_portion}${element(split(",", var.public-route-variable), count.index)}"
    availability_zone = "${element(split(",", var.availability_zone), count.index)}"
    map_public_ip_on_launch = true
    tags {
        Name = "${element(split(",", var.environment), count.index)}-public-route-variable-${element(split(",", var.availability_zone), count.index)}"
    }
}

resource "aws_subnet" "protected-route-nat" {
    count = "${length(compact(split(",", var.protected-route-nat)))}"
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.ip_address_network_portion}${element(split(",", var.protected-route-nat), count.index)}"
    availability_zone = "${element(split(",", var.availability_zone), count.index)}"
    tags {
        Name = "${element(split(",", var.environment), count.index)}-protected-route-nat-${element(split(",", var.availability_zone), count.index)}"
    }
}

resource "aws_subnet" "private-route-local" {
    count = "${length(compact(split(",", var.private-route-local)))}"
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.ip_address_network_portion}${element(split(",", var.private-route-local), count.index)}"
    availability_zone = "${element(split(",", var.availability_zone), count.index)}"
    tags {
        Name = "${element(split(",", var.environment), count.index)}-private-route-local-${element(split(",", var.availability_zone), count.index)}"
    }
}

##################
# VPC RouteTable
##################


resource "aws_internet_gateway" "internet-gateway" {
    vpc_id ="${aws_vpc.vpc.id}"
    tags {
        Name = "internet-gateway"
    }
}

# public-route-igw

resource "aws_route_table" "public-route-igw-table" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.internet-gateway.id}"
    }
    tags {
        Name = "public-route-igw-table"
    }
}

resource "aws_main_route_table_association" "main-route-table" {
    vpc_id = "${aws_vpc.vpc.id}"
    route_table_id = "${aws_route_table.public-route-igw-table.id}"
}

resource "aws_route_table_association" "public-route-igw" {
    count = "${length(compact(split(",", var.public-route-igw)))}"
    subnet_id = "${element(aws_subnet.public-route-igw.*.id, count.index)}"
    route_table_id = "${aws_route_table.public-route-igw-table.id}"
}


# public-route-variable

resource "aws_route_table" "public-route-variable-table" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.internet-gateway.id}"
    }
    tags {
        Name = "public-route-variable-table"
    }
}

resource "aws_route_table_association" "public-route-variable" {
    count = "${length(compact(split(",", var.public-route-variable)))}"
    subnet_id = "${element(aws_subnet.public-route-variable.*.id, count.index)}"
    route_table_id = "${aws_route_table.public-route-variable-table.id}"
}

# protected-route-nat

resource "aws_route_table" "protected-route-nat-table" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "protected-route-nat-table"
    }
}

resource "aws_route_table_association" "protected-route-nat" {
    count = "${length(compact(split(",", var.protected-route-nat)))}"
    subnet_id = "${element(aws_subnet.protected-route-nat.*.id, count.index)}"
    route_table_id = "${aws_route_table.protected-route-nat-table.id}"
}

# private-route-local


resource "aws_route_table" "private-route-local-table" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "private-route-local-table"
    }
}

resource "aws_route_table_association" "private-route-local" {
    count = "${length(compact(split(",", var.private-route-local)))}"
    subnet_id = "${element(aws_subnet.private-route-local.*.id, count.index)}"
    route_table_id = "${aws_route_table.private-route-local-table.id}"
}
