resource "aws_security_group" "bastion" {
    name = "bastion-security-group"
    vpc_id = var.vpc_id

    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol = -1
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "aws_security_group.bastion_jenkins"
    }
}

resource "aws_key_pair" "bastion" {
    key_name = "bastion-key-jenkins"
    public_key = var.public_key
}

# data "aws_ssm_parameter" "linux2_ami" { 
#  	name = "/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-ebs" 
# } 

resource "aws_instance" "bastion" {
    ami = "****"
    instance_type = "t2.micro"
    key_name = aws_key_pair.bastion.key_name
    associate_public_ip = true
    subnet_id = element(aws_subnets.public_subnets, 0).id
    vpc_security_group_ids = [aws_security_group.bastion.id]

    tags = {
        Name = "jenkins-bastion"
    }
}

output "bastion" {
    value = aws_instance.bastion.public_ip
}
