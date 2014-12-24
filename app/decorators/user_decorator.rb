class UserDecorator < Draper::Decorator
  delegate_all
  
  def followers
    h.number_with_delimiter(object.followers)
  end
  
  def followers_label
    h.followers_label(object.followers)
  end
  
  def url
    "http://twitter.com/#{self.name}"
  end

end
