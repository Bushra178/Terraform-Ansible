output "ec2-public-ip" {
    value = module.myapp-server.instance.public_ip
}