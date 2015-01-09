class App < ActiveRecord::Base
  attr_accessible :consumer_key, :consumer_secret, :name
  attr_reader :result_tweet, :has_twitter_error, :user
  
  has_many :users, :dependent => :destroy
  
  def scope
    self.users.map(&:followers).reduce(:+) || 0
  end
  
  def run(current_user)
    @has_twitter_error = false
    @user = current_user
    @twitter_client = TwitterAccess.new(self, @user).client
  end
  
  def tweet
    @twitter_client.update(result_tweet) unless Rails.env.development? || self.has_twitter_error
  end
  
  
end
