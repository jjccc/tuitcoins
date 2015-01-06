class User < ActiveRecord::Base
  attr_accessible :followers, :name
  
  has_many :campaigns, :dependent => :destroy
  belongs_to :app
  
  paginates_per 10
  
  def self.scope
    User.all.map(&:followers).reduce(:+) || 0
  end

  # Copia todas las campañas por defecto al usuario, activando todas ellas.
  def create_default_campaigns    
    Campaign.where(:is_default => true, :user_id => nil).each do |campaign|
      new_campaign = campaign.dup
      new_campaign.is_default = false
      new_campaign.is_active = true
      self.campaigns << new_campaign
      new_campaign.activate
    end
  end
  
  def self.create_with_omniauth(auth, app)
    create! do |user|  
      user.uid = auth["uid"]
      user.app_id = app.id
      user.name = auth["info"]["nickname"]  
      user.oauth_token = auth["credentials"]["token"]
      user.oauth_secret = auth["credentials"]["secret"]
      user.picture = auth["info"]["image"]
      user.followers = TwitterAccess.new(app, user).client.user(auth["info"]["nickname"]).followers_count
    end 
  end
  
end
