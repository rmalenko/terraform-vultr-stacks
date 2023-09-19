data "github_user" "aws" {
  username = var.username
}

resource "github_repository" "aws" {
  name                 = var.repo_name
  description          = var.description
  visibility           = var.visibility
  auto_init            = var.auto_init
  has_issues           = var.has_issues
  has_discussions      = var.has_discussions
  gitignore_template   = var.gitignore_template
  license_template     = var.license_template
  vulnerability_alerts = true
  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }
}

locals {
  unique_environments = tolist(distinct([for rule in var.environment_git : rule.env_name if can(rule.env_name)]))
  environment         = compact(distinct(local.unique_environments))

}

resource "github_repository_environment" "aws" {
  for_each    = toset(local.environment)
  environment = each.key
  repository  = github_repository.aws.name
  reviewers {
    users = [data.github_user.aws.id]
  }
  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
  depends_on = [github_repository.aws]
}

resource "github_actions_environment_variable" "aws" {
  for_each = {
    for idx, rule in var.environment_git :
    idx => {
      env_name      = can(rule.env_name) ? rule.env_name : null
      env_var_name  = can(rule.env_var_name) ? rule.env_var_name : null
      env_var_value = can(rule.env_var_value) ? rule.env_var_value : null
    }
  }
  repository    = github_repository.aws.name
  environment   = each.value.env_name
  variable_name = each.value.env_var_name
  value         = each.value.env_var_value
  depends_on    = [github_repository_environment.aws]
}

resource "github_actions_environment_secret" "aws" {
  for_each = {
    for idx, rule in var.secrets_git :
    idx => {
      env_name               = can(rule.env_name) ? rule.env_name : null
      secret_name            = can(rule.secret_name) ? rule.secret_name : null
      secret_value_plaintext = can(rule.secret_value_plaintext) ? rule.secret_value_plaintext : null
      secret_value_encrypted = can(rule.secret_value_encrypted) ? rule.secret_value_encrypted : null
    }
  }
  repository      = github_repository.aws.name
  environment     = each.value.env_name
  secret_name     = each.value.secret_name
  plaintext_value = each.value.secret_value_plaintext
  # encrypted_value = each.value.secret_value_encrypted
  depends_on = [github_repository_environment.aws]
}

resource "github_branch" "aws" {
  for_each   = var.branches
  repository = github_repository.aws.name
  branch     = each.key
  depends_on = [github_repository.aws]
}

resource "github_branch_default" "aws" {
  repository = github_repository.aws.name
  branch     = var.default_branch
  depends_on = [github_branch.aws]
}

resource "github_branch_protection" "aws" {
  repository_id    = github_repository.aws.name
  pattern          = var.default_branch
  enforce_admins   = true
  allows_deletions = true
  # required_status_checks {
  #   strict   = false
  #   contexts = ["ci/travis"]
  # }
  # required_pull_request_reviews {
  #   dismiss_stale_reviews = true
  #   restrict_dismissals   = true
  #   # dismissal_restrictions = [
  #   #   data.github_user.example.node_id,
  #   #   github_team.example.node_id,
  #   #   "/exampleuser",
  #   #   "exampleorganization/exampleteam",
  #   # ]
  # }
  #   push_restrictions = [
  #     data.github_user.example.node_id,
  #     "/exampleuser",
  #     "exampleorganization/exampleteam",
  #     # limited to a list of one type of restriction (user, team, app)
  #     # github_team.example.node_id
  #   ]

  #   force_push_bypassers = [
  #     data.github_user.example.node_id,
  #     "/exampleuser",
  #     "exampleorganization/exampleteam",
  #     # limited to a list of one type of restriction (user, team, app)
  #     # github_team.example.node_id
  #   ]
  depends_on = [github_branch.aws]
}

resource "github_issue_label" "aws" {
  repository = github_repository.aws.name
  name       = "Urgent"
  color      = "FF0000"
}

resource "github_repository_file" "aws" {
  repository          = github_repository.aws.name
  branch              = "development"
  file                = ".github/workflows/ssh_action.yml"
  content             = file("${path.module}/templates/ssh_action.yml")
  commit_message      = "Workflow template. Managed by Terraform."
  commit_author       = "rmalenko"
  commit_email        = "rmalenko@gmail.com"
  overwrite_on_create = true
}