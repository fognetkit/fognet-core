data "aws_ami" "ubuntu_24_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-*-24.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "gateway-sg" {
  name   = "gateway-security-group"
  vpc_id = aws_vpc.gateway-net.id

  dynamic "ingress" {
    for_each = var.network.allow_ping ? [1] : []
    content {
      protocol    = "ICMP"
      description = "Allow ping"
      from_port   = -1
      to_port     = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = var.network.ports
    content {
      protocol    = ingress.value.protocol
      description = ingress.value.description
      from_port   = lookup(ingress.value, "port", null)
      to_port     = lookup(ingress.value, "port", null)
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.network.allow_outgoing ? [1] : []
    content {
      protocol    = "-1"
      description = "Allow all outgoing"
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = merge(local.default_labels, { type = "security_group" })
}

resource "aws_instance" "fognet-server" {
  availability_zone           = var.aws.zone
  ami                         = data.aws_ami.ubuntu_24_04.id
  instance_type               = var.aws_instance_type
  subnet_id                   = aws_subnet.gateway-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.gateway-sg.id]

  user_data = templatefile("${path.module}/../template/cloud-init.yml.tpl", {
    packages     = var.packages
    mount_bucket = var.mount_bucket
    bucket_props = var.bucket_props
    run_commands = var.run_commands
  })

  tags = merge(local.default_labels, { type = "instance" })
}
