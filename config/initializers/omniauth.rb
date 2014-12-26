Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, Tuitcoins::Application.config.twitter_consumer_key, Tuitcoins::Application.config.twitter_consumer_secret
end  