class TwitterUser

  attr_reader :name, :nick, :picture, :value
  
  def initialize(current_name, current_nick, current_picture, current_value)
    @nick = current_nick
    @name = current_name
    @picture = current_picture
    @value = current_value
  end
  
end