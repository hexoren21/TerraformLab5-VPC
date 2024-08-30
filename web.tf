resource "aws_instance" "web_host" {
  ami                    = "ami-0e04bcbe83a83792e"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_ec2_key.id
  subnet_id              = aws_subnet.priv_sub1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = <<-EOF
		    #!/bin/bash
		    sudo apt update
		    sudo apt install apache2 wget unzip -y
		    wget https://www.tooplate.com/zip-templates/2135_mini_finance.zip
		    unzip 2135_mini_finance.zip
		    sudo cp -r 2135_mini_finance/* /var/www/html/
		    sudo systemctl restart apache2
		    EOF		

  tags = {
    Name = "web-vm"
  }
}

resource "aws_security_group" "web_sg" {
  name   = "web-sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}