output "instance_public_ip" {
  description = "Public IP of the inference server"
  value       = aws_instance.inference_server.public_ip
}

output "api_endpoint" {
  description = "API Endpoint for the inference service"
  value       = "http://${aws_instance.inference_server.public_ip}:8000"
}
