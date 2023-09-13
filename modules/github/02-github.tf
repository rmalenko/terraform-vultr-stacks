data "github_user" "aws" {
  username = var.git_username
}

resource "github_repository" "aws" {
  name                 = var.repo_name
  description          = "AWS ALB EC2 R53 IAM"
  visibility           = "public"
  auto_init            = true
  has_issues           = true
  has_discussions      = true
  gitignore_template   = "Terraform"
  license_template     = "apache-2.0"
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

resource "github_repository_environment" "aws" {
  for_each    = toset([for env in values(var.environment_git) : env.env_name]) # dedublicated 
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
  for_each      = var.environment_git
  repository    = github_repository.aws.name
  environment   = lookup(var.environment_git[each.key], "env_name", null)
  variable_name = lookup(var.environment_git[each.key], "env_var_name", null)
  value         = lookup(var.environment_git[each.key], "env_var_value", null)
  depends_on    = [github_repository_environment.aws]
}

resource "github_actions_environment_secret" "aws" {
  for_each    = var.environment_git
  repository  = github_repository.aws.name
  environment = lookup(var.environment_git[each.key], "env_name", null)
  secret_name = lookup(var.environment_git[each.key], "secret_name", null)
  #   plaintext_value = lookup(var.environment_git[each.key], "secret_value_plaintext", null)
  encrypted_value = lookup(var.environment_git[each.key], "secret_value_encrypted", null)
  depends_on      = [github_repository_environment.aws]
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
  required_status_checks {
    strict   = false
    contexts = ["ci/travis"]
  }
  required_pull_request_reviews {
    dismiss_stale_reviews = true
    restrict_dismissals   = true
    # dismissal_restrictions = [
    #   data.github_user.example.node_id,
    #   github_team.example.node_id,
    #   "/exampleuser",
    #   "exampleorganization/exampleteam",
    # ]
  }
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
