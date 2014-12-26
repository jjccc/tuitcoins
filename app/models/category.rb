class Category < ActiveRecord::Base
  attr_accessible :name
  
  has_many :plans
  
  paginates_per 10
end
