require 'omniauth_setup'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, setup: OmniauthSetup
end