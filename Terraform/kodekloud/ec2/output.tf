output "public_ip" {
  value = aws_instance.webserver.public_ip
}

output "ssh_command" {
  value = "ssh -i ${path.root}/terraform_ssh_key.pem ubuntu@${aws_instance.webserver.public_ip}"
  sensitive = false 
}