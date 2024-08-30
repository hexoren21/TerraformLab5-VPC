resource "tls_private_key" "my_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "my_ec2_key" {
  key_name   = "my-ec2-key"
  public_key = tls_private_key.my_ec2_key.public_key_openssh
}