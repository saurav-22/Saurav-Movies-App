# Create security group for Bastion Host
resource "aws_security_group" "tf-bastion-sg" {
  name        = "TF-Bastion-SG"
  description = "Security group for Bastion Host"
  vpc_id      = aws_vpc.tf-vpc.id
}

# Egress Rules for Bastion Host
resource "aws_vpc_security_group_egress_rule" "tf-bastion-sg-egress" {
  security_group_id = aws_security_group.tf-bastion-sg.id
  /* from_port         = 443
  to_port           = 443 */
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "tf-bastion-sg-egress-1" {
  security_group_id = aws_security_group.tf-bastion-sg.id
  /* from_port         = 0
  to_port           = 0 */
  ip_protocol       = "-1"
  cidr_ipv4         = aws_vpc.tf-vpc.cidr_block
}

/* # Create security group for ALB
resource "aws_security_group" "tf-alb-sg" {
  name        = "TF-ALB-SG"
  description = "Security group for ALB"
  vpc_id = aws_vpc.tf-vpc.id
}

# Ingress Rules for ALB
resource "aws_vpc_security_group_ingress_rule" "tf-alb-sg-ingress" {
  security_group_id = aws_security_group.tf-alb-sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4        = "0.0.0.0/0"
}
resource "aws_vpc_security_group_ingress_rule" "tf-alb-sg-ingress-1" {
  security_group_id = aws_security_group.tf-alb-sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4        = "0.0.0.0/0"
}
# Egress rule for ALB
resource "aws_vpc_security_group_egress_rule" "tf-alb-sg-egress" {
  security_group_id = aws_security_group.tf-alb-sg.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4        = "0.0.0.0/0"
}

# Create security group for ECS
resource "aws_security_group" "tf-ecs-sg" {
  name        = "TF-ECS-SG"
  description = "Security group for ECS"
  vpc_id = aws_vpc.tf-vpc.id
}

# Create Ingress rule for ECS SG
resource "aws_vpc_security_group_ingress_rule" "tf-ecs-sg-ingress" {
  security_group_id = aws_security_group.tf-ecs-sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  referenced_security_group_id = aws_security_group.tf-alb-sg.id
}
resource "aws_vpc_security_group_ingress_rule" "tf-ecs-sg-ingress-1" {
  security_group_id = aws_security_group.tf-ecs-sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  referenced_security_group_id = aws_security_group.tf-alb-sg.id
}

# Create Egress rule for ECS SG
resource "aws_vpc_security_group_egress_rule" "tf-ecs-sg-egress" {
  security_group_id = aws_security_group.tf-ecs-sg.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4        = "0.0.0.0/0"
}
 */