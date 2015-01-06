class OmniauthSetup
  # OmniAuth expects the class passed to setup to respond to the #call method.
  # env - Rack environment
  def self.call(env)
    new(env).setup
  end

  # Assign variables and create a request object for use later.
  # env - Rack environment
  def initialize(env)
    @env = env
    @request = ActionDispatch::Request.new(env)
  end

  #private

  # The main purpose of this method is to set the consumer key and secret.
  def setup
    @env['omniauth.strategy'].options.merge!(custom_credentials)
  end

  # Use the subdomain in the request to find the app with credentials
  def custom_credentials    
    app = App.find_by_subdomain(@request.query_parameters["app"])
    
    # {
      # client_id: app.consumer_key,
      # client_secret: app.consumer_secret
    # }
    {
      consumer_key: app.consumer_key,
      consumer_secret: app.consumer_secret
    }
  end
end