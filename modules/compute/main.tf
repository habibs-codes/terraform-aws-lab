# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "web" {
  vpc_id = var.vpc_id
  name   = "tf-web-sg"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "tf-web-sg" }
}

# -----------------------------
# EC2 Instance
# -----------------------------
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_name

  tags = { Name = "tf-web-server" }

  depends_on = [aws_security_group.web]
}

