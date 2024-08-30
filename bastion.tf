resource "aws_instance" "bastion_host" {
  ami                    = "ami-0e04bcbe83a83792e"
  instance_type          = "t2.micro"
  key_name               = "web02"
  subnet_id              = aws_subnet.pub_sub1.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo '${tls_private_key.my_ec2_key.private_key_pem}' > /home/ubuntu/my-ec2-key.pem
              chmod 600 /home/ec2-user/my-ec2-key.pem
              chown ec2-user:ec2-user /home/ec2-user/my-ec2-key.pem
            EOF

  tags = {
    Name = "Bastion-vm"
  }
}

resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["77.65.96.55/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}