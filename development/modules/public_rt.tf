resource "aws_internet_gateway" "igw" {
    vpc_id = var.vpc_id

    tags = {
        Name = "igw_jenkins"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "public_rt_jenkins"    
    }
}

resource "aws_route_table_association" "public" {
    count = var.public_subnets_count
    subnet_id = element(var.public_subnets.*.id, count.index)
    route_table_id = aws_ro
}