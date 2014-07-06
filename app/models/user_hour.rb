class UserHour < ActiveRecord::Base
  belongs_to :entry
  belongs_to :category
  belongs_to :subcategory
  
end
