class App < ActiveRecord::Base
  attr_accessible :consumer_key, :consumer_secret, :name
  attr_reader :result_tweet
  
  has_many :users, :dependent => :destroy
  
  def scope
    self.users.map(&:followers).reduce(:+) || 0
  end
  
  def run(current_user)
    @user = current_user
    @twitter_client = TwitterAccess.new(self, @user).client
  end
  
  def tweet
    @twitter_client.update(result_tweet) unless Rails.env.development?
  end
  
  
end
