#TODO: Download a user's data to localStorage so they can access it offline

class ProfileController < ApplicationController
	# before_filter :redirect_to_login if not session[:user_id]

	def index
		@user = User.find_by_email(session[:user_id])
		@new_user = false
		unless @user
			redirect_to(:controller => 'login', :action=> 'signup')
		else
			if @user.entries.empty?
				@new_user = true
				sample = Entry.create(:description => "Click me, then click 'Show Detail'",
										 :username => "Your username or login name to some site",
										 :password => "Your passwords are always encrypted",
										 :user =>@user)
			end
		end
	end

	def create
		user =  User.find_by_email(session[:user_id])
		entry = Entry.create(:user => user, 
													:description => params[:description],
													:username => params[:username],
													:password => params[:password])
		result = { :entry_id => entry.id, :description => entry.description}
		respond_to do |format|		
   		format.json { render :json => result.as_json }
   	end
	end

	def show
		e = Entry.find(params[:entry_id])
		@decrypted = Entry.new( :description => e.description, 
														:username => e.username,
														:password => e.decrypted_password)
		respond_to do |format|
   		format.json { render :json => @decrypted.as_json }
   	end
	end

	def hide
		@decrypted = nil
		respond_to do |format|
			result = {:result => true}
			format.json { render :json => result.as_json}
		end
	end

	def delete
		e = Entry.find(params[:entry_id])
		e.destroy
		redirect_to(:action => 'index')
	end

end
