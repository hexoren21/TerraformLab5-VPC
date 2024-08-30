output "public_ip" {
  value       = aws_instance.bastion_host.public_ip
  description = "Public address IP Bastion"
}

output "private_ip" {
  value       = aws_instance.web_host.private_ip
  description = "Private address IP web"
}