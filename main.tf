provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "engdevopsb06terraformstate"
    key    = "pipeline.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "my_ami" {
     most_recent      = true
     #name_regex       = "^mavrick"
     owners           = ["053490018989"]
}


resource "aws_instance" "web-1" {
    ami = "${data.aws_ami.my_ami.id}"
    #ami = "ami-0d857ff0f5fc4e03b"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "LaptopKey"
    subnet_id = "subnet-0d6dcc6af907c7833"
	private_ip = "10.1.1.111"
    vpc_security_group_ids = ["sg-061702a493dca1e89"]
    associate_public_ip_address = true	
    tags = {
        Name = "Server-1"
        Env = "Prod"
        Owner = "Sree"
    }
}
