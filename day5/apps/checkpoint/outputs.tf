
output "remote_add" {
  value = format("\ngit remote add devops %s\ngit push devops master", data.azuredevops_git_repositories.default.repositories[0].ssh_url)
}

