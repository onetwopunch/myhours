require 'uuid'
require 'digest/sha1'

class TempPassword < ActiveRecord::Base
	before_save :create_password
	
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
	validates :email, :presence => true, :length => { :within => 5..100 }, 
		:format=>EMAIL_REGEX, :confirmation => true, :uniqueness=>true

	def create_password
		self.uuid = Digest::SHA1.hexdigest(get_uuid)
	end

	def get_uuid
		UUID.state_file = false
		UUID.generator.next_sequence
		UUID.new.generate
	end

end
