resource "aws_security_group" "lb" {
    name = "ecs-alb-security-group"
    vpc_id = var.vpc_id

    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 8080
        cidr_block = ["0.0.0.0/0"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_block = ["0.0.0.0/0"]
    }

    tags = {
        Name = "jenkins-lb-sg"
    }
}

resource "aws_elb" "jenkins_elb" {
    instances = [aws_instance.jenkins_master.id]
    security_groups = [aws_security_group.lb.id]
    cross_zone_load_balancing = true
    subnets = [for subnet in aws_subnets.public_subnets : subnet.id]
    
    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      target = "TCP:8080"
      interval = 5
    }
    
    listener {
      lb_port = 80
      lb_protocol = http
      instance_port = 8080
      instance_protocol = http
    }

    tags = {
        Name = "jenkins_elb"
    }
}
