class Entry < ActiveRecord::Base
  has_many :user_hours
  belongs_to :user
  has_many :categories, through: :user_hours
  
  
  def self.create_entry(user, hours_array)
    puts hours_array
    
    "entry"
  end
end
