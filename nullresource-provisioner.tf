resource "null_resource" "name" {

  depends_on = [ module.ec2_public ]
  

  connection {
    type     = "ssh"
    user     = "ec2-user"
    #password = "${var.root_password}"
    host     =  aws_eip.bastion_eip.public_ip
    private_key = file("terraform-kp.pem")
  }


  provisioner "file" {
    source = "terraform-kp.pem"
    destination = "/tmp/terraform-kp.pem"
  }


  provisioner "remote-exec" {
    inline = [ 
        "sudo chmod 400 /tmp/terraform-kp.pem"
     ]
  }

  #terraform apply default
  provisioner "local-exec" {
    command = "echo Creation Time Provisioner VPC created on `date` with VPC ID : ${module.vpc.vpc_id} >> creation_time_vpc.txt"
    working_dir = "/"
    on_failure = continue
    #when = destroy
  }

#   #terraform destroy
#   provisioner "local-exec" {
#     command = "echo Destroy Time Provisioner VPC Destroyed : ${module.vpc.vpc_id} >> destroy_time_vpc.txt"
#     working_dir = "/"
#     #on_failure = continue
#     when = destroy
#   }
}

  


#Creation Time Provisioner > Default
#Destroy Time Provisioner