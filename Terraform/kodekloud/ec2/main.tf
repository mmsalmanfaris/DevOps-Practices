# Get the latest ubuntu OS images
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get public subnet in the default VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

# Generate Private Key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

# Save the private key locally
resource "local_file" "tls_private_key" {
  content = tls_private_key.ssh_key.private_key_pem
  filename = "${path.root}/terraform_ssh_key.pem"
}

#save the generated key to aws instance
resource "aws_key_pair" "ssh-generated-key" {
  key_name = "terraform_ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}


resource "aws_security_group" "allow_ssh" {
    name        = "allow_ssh"
    description = "Allow SSH inbound traffic and all outbound traffic"
    vpc_id      = data.aws_vpc.default.id

    ingress {
        description = "SSH from anywhere"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    # Allow all outbound traffic (essential for internet access)
    egress {
        description = "All outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_ssh_security_group"
    }
}

resource "aws_instance" "webserver" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = "t2.micro"
    key_name              = aws_key_pair.ssh-generated-key.key_name
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    subnet_id             = data.aws_subnets.public.ids[0]
    
    # Ensure public IP assignment
    associate_public_ip_address = true
    
    tags = {
        Name = "Kode Kloud Learning"
    }
}