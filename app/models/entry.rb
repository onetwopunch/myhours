class Entry < ActiveRecord::Base
  has_many :user_hours
  belongs_to :user
  has_many :categories, through: :user_hours
end
