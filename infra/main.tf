


resource "aws_instance" "SQ" {
  ami                    = "ami-0ecb62995f68bb549"      #change ami id for different region
  instance_type          = "t3.small"
  key_name               = "EC2-key"              #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.VM-SG.id]
  user_data_base64 = base64encode(file("./install2.sh"))
   subnet_id             = aws_subnet.gad_subnet.id
  tags = {
    Name = "SonarQube"
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}

resource "aws_security_group" "VM-SG" {
  name        = "VM-SG"
  description = "Allow TLS inbound traffic"
   vpc_id      = aws_vpc.gad_vpc.id

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VM-SG"
  }
}



resource "aws_instance" "Jenkins" {
  ami                    = "ami-0ecb62995f68bb549"      #change ami id for different region
  instance_type          = "t3.micro"
  key_name               = "EC2-key"              #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.VM-SG.id]
  user_data_base64 = base64encode(file("./install1.sh"))
  subnet_id             = aws_subnet.gad_subnet.id
  tags = {
    Name = "Jenkins"
  }

  root_block_device {
    volume_size = 12
    volume_type = "gp2"
  }
}

