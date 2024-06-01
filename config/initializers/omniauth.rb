# Rails.application.config.middleware.use OmniAuth::Builder do
  # configure do |config|
  #   config.path_prefix = '/auth'
  #   config.allowed_request_methods = %i[post get]
  # end

  # OmniAuth.config.silence_get_warning = true

#   client_options = {
#     scheme: 'https',
#     host: 'oidc.login.xyz',
#     port: 443,
#     authorization_endpoint: '/authorize',
#     token_endpoint: '/token',
#     userinfo_endpoint: '/userinfo',
#     jwks_uri: '/jwk',
#     identifier: 'e47a5c5b-bffd-4b45-bf46-45efa564f2e5',
#     secret: 'TdY1Ze3ejSMLvVB2'
#   }

#   provider :siwe, issuer: 'https://oidc.login.xyz/', client_options: client_options
# end