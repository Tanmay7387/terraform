provider "aws" {
    region = "us-east-1"
  
}

resource "aws_instance" "test1" {
    ami = "ami-0182f373e66f89c85"
    instance_type = "t2.micro"
    key_name = key1
    vpc_security_group_ids = [ aws_security_group.SG-2.id ]
  
}

resource "aws_security_group" "SG-2" {
    name = "terra_security"

connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file ("./key1.pem")
    host     = self.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo yum install -y nginx",
      "sudo systemctl start nginx",
      "mkdir /home/ec2-user/testo",
    ]
  }
}

resource "aws_vpc_security_group_ingress_rule" "SG-1_ipv4" {
  security_group_id = aws_security_group.SG-1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  
}

resource "aws_vpc_security_group_ingress_rule" "SG-2_ipv4" {
  security_group_id = aws_security_group.SG-1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.SG-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}