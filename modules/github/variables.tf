variable "repo_name" {
  type        = string
  description = "A name for repo"
}

variable "branches" {
  type        = set(string)
  description = "List of Git branches"
}


variable "default_branch" {
  type        = string
  description = "The default branch"
}

variable "environment_git" {
  description = "Environment configurations for the GitHub module"
  type = map(object({
    env_name               = string
    env_var_name           = string
    env_var_value          = string
    secret_name            = string
    secret_value_plaintext = string
    secret_value_encrypted = string
  }))
}

variable "git_username" {
  type        = string
  description = "Git username"
}
