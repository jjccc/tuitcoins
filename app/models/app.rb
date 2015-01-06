class App < ActiveRecord::Base
  attr_accessible :consumer_key, :consumer_secret, :name  
  
  has_many :users, :dependent => :destroy
  
  def scope
    self.users.map(&:followers).reduce(:+) || 0
  end
  
  def run(current_user)
    @user = current_user
  end
  
  
end
