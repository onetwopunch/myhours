class Site < ActiveRecord::Base
  belongs_to :user
  has_one :supervisor
  belongs_to :entry
end
