#TODO: Download a user's data to localStorage so they can access it offline

class ProfileController < ApplicationController
	# before_filter :redirect_to_login if not session[:user_id]

	def index
		@user = User.find_by_email(session[:user_id])
		unless @user
			redirect_to(:controller => 'login', :action=> 'signup')
		end
	end


end
