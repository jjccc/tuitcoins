class Plan < ActiveRecord::Base
  attr_accessible :category_id, :link, :name, :tweet
 
  belongs_to :category
  has_many :campaigns
  
  paginates_per 10
end
