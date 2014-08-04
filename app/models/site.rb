class Site < ActiveRecord::Base
  belongs_to :user
  has_one :supervisor, dependent: :delete
  belongs_to :entry
  validates :name, uniqueness: true
end
