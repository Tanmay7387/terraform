output "instance_id" {
    value = aws_instance.test1.id
}

output "instance_ip" {
    value = aws_instance.test1.public_ip
}