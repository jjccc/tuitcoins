class PlanDecorator < Draper::Decorator
  delegate_all
  
  def category_name
    object.category.name
  end

  def tweet
    "#{object.tweet} #{object.link}"
  end
  
end
