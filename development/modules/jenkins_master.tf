resource "aws_instance" "jenkins_master" {
    ami = "****"
    instance_type = "t2.micro"
    key_name = aws_key_pair.bastion.key_name
    subnet_id = element(aws_subnets.private_subnets, 0).id
    vpc_security_group_ids = [aws_security_group.jenkins_master_sg.id]

    root_block_device {
      volume_size = 8
      volume_type = "gp3"
      delete_on_termination = false
    }

    tags = {
        Name = "jenkins_master"
    }
}


resource "aws_key_pair" "jenkins" {
    key_name = "key-jenkins"
    public_key = var.public_key
}

# data "aws_ami" "jenkins-master" { 
#  	most_recent = true
#     owners = ["self"] 
# } 

resource "aws_security_group" "jenkins_master_sg" {
    name = "jenkins_master_sg"
    description = "Allow traffic on port 8080 and enable SSH"
    vpc_id = var.vpc_id

    ingress {
        protocol = "tcp"
        from_port = "22"
        to_port = "22"
        security_groups = [aws_security_group.bastion.id]
    }

    ingress {
        protocol = "tcp"
        from_port = "8080"
        to_port = "8080"
        security_groups = [aws_security_group.lb.id]
    }

    ingress {
        protocol = "tcp"
        from_port = "8080"
        to_port = "8080"
        cidr_block = ["0.0.0.0/0"]
    }

    egress {
        protocol = "-1"
        from_port = "0"
        to_port = "0"
        cidr_block = ["0.0.0.0/0"]
    }

    tags = {
        Name = "jenkins_master_sg"
    }
}
