class User < ActiveRecord::Base
  attr_accessible :followers, :name
  
  has_many :campaigns
  
  paginates_per 10
  
  def self.scope
    User.all.map(&:followers).reduce(:+) || 0
  end 
  
  def self.create_with_omniauth(auth)
    create! do |user|  
      user.uid = auth["uid"]  
      user.name = auth["info"]["nickname"]  
      user.oauth_token = auth["credentials"]["token"]
      user.oauth_secret = auth["credentials"]["secret"]
      user.image = auth["info"]["image"]
      user.followers = TwitterAccess.new(user).client.user(auth["info"]["nickname"]).followers_count
    end 
  end
  
end
