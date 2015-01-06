class TwitterAccess
  
  attr_accessor :client
  
  def initialize(app, user = nil)
    self.client = Twitter::REST::Client.new do |config|
      config.consumer_key        = app.consumer_key
      config.consumer_secret     = app.consumer_secret
      config.access_token        = user.oauth_token unless user.nil?
      config.access_token_secret = user.oauth_secret unless user.nil?
    end
  end
  
end