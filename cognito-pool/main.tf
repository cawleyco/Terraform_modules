resource "aws_cognito_user_pool" "user-pool" {
  name = var.name

  admin_create_user_config {
    allow_admin_create_user_only = var.allow_admin_create_user_only
  }

  username_attributes = [
    "email",
  ]

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 10
    require_lowercase = false
    require_uppercase = false
    require_symbols   = false
    require_numbers   = false
  }
}

resource "aws_cognito_user_pool_client" "pool-client" {
  name                = var.client_name
  generate_secret     = false                 # There is a limitation in 'Amplify' that means we can't set this to TRUE
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"] # Enable sign-in API for server-based authentication (ADMIN_NO_SRP_AUTH)

  user_pool_id = aws_cognito_user_pool.user-pool.id

  depends_on = [aws_cognito_user_pool.user-pool]
}

