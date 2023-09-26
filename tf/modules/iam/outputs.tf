output "helloworld_user_access_key" {
  value = aws_iam_access_key.helloworld_user_key.id
  sensitive = true
}

output "helloworld_user_secret_key" {
  value = aws_iam_access_key.helloworld_user_key.secret
  sensitive = true
}