# Get Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-minimal-*-x86_64"]
  }

  owners = ["137112412989"] # Amazon
}

# Create an EC2 On-Demand Instance
resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.tf-private-subnets["1a"].id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.tf-bastion-sg.id]
  iam_instance_profile        = "Bastion-Host-Role"
  user_data_base64            = "IyEvYmluL2Jhc2gNCnN1ZG8geXVtIHVwZGF0ZSAteQ0KYXdzIHMzIGNwIHMzOi8vc2F1cmF2LXNjcmlwdHMvcGFja2FnZXMtaW5zdGFsbGF0aW9uLnNoIC90bXAvcGFja2FnZXMtaW5zdGFsbGF0aW9uLnNoDQpjaG1vZCAreCAvdG1wL3BhY2thZ2VzLWluc3RhbGxhdGlvbi5zaA0KL3RtcC9wYWNrYWdlcy1pbnN0YWxsYXRpb24uc2g="
  root_block_device {
    volume_size = 15
  }

  tags = {
    Name = "BastionHost"
  }
}