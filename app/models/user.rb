class User < ActiveRecord::Base
  attr_accessible :followers, :name
  
  has_many :campaigns
  
  paginates_per 1
  
  def self.followers
    User.all.map(&:followers).reduce(:+) || 0
  end 
  
end
