module "ec2_private" {
  depends_on = [ module.vpc ]
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"



  name = "${var.environment}-private-vm"

  ami                         = data.aws_ami.amzlinux2.id
  instance_type               = var.instance_type
  key_name                    = var.instance_keypair
  #availability_zone          = element(module.vpc.azs, 0)
  for_each                    = toset(["0", "1"]) 
  subnet_id                   =  element(module.vpc.private_subnets, tonumber(each.key))
  #instance_count             = var.private_instance_count
  user_data                   = file("app1-install.sh")
  

  vpc_security_group_ids      = [module.private_sg.security_group_id]
  tags = local.common_tags
}