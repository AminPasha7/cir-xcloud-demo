terraform { required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } } }
provider "aws" { region = var.region }
resource "aws_security_group" "cir_demo" {
  name = "cir-demo-sg"
  description = "CIR demo SG"
  vpc_id = var.vpc_id
  tags = { Name = "cir-demo" }
}
output "demo_sg_id" { value = aws_security_group.cir_demo.id }
