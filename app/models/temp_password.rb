require 'uuid'
require 'digest/sha1'

class TempPassword < ActiveRecord::Base
	before_save :create_password
	
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
	validates :email, :presence => true, :length => { :within => 5..100 }, 
		:format=>EMAIL_REGEX, :confirmation => true
	# validates :uuid, :presence => true, :uniqueness => true

	def create_password
		self.uuid = TempPassword.get_uuid
		self.hashed_uuid = Digest::SHA1.hexdigest(uuid)
	end

	def self.validate_password(uuid)
		hashed_uuid = Digest::SHA1.hexdigest(uuid)
		tmp = TempPassword.find_by_hashed_uuid(hashed_uuid)
		if tmp
			user = User.find_by_email(tmp.email)
			if user
				return user
			else
				puts "No user found with the email " + tmp.email
				return false
			end
		else
			puts "No temp password found to match " + hashed_uuid
			return false
		end
	end


	def self.get_uuid
		UUID.state_file = false
		UUID.generator.next_sequence
		UUID.new.generate
	end

end
