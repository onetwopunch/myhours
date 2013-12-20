class LoginController < ApplicationController
	
	before_filter :redirect_to_profile, :only => [:signup, :index]

	def index
		#log in form		
	end

	def authenticate
		unless session[:user_id]
			user = User.authenticate(params[:email], params[:password])
			if user
				session[:user_id] = user.email	
				redirect_to(:controller=>'profile', :action =>'index')
			else 
				flash[:notice] = "You are not in our system, try signing up!"
				redirect_to(:action =>'index')
			end
		end
	end

	def check_email_exists
		email = params[:email]
		user = User.find_by_email(email)		
		respond_to do |format|	
			if user
	   		format.json { render :json => {:response => "user_exists"}.as_json }
			else
	   		format.json { render :json => {:response => "user_not_exists"}.as_json }
	   	end
   	end 
	end


	def logout
		session[:user_id] = nil
		render 'index'
	end

	def signup 
		@user = User.new
	end
	
	def create
		user = User.create(user_params)
		session[:user_id] = user.email
		redirect_to(:controller=>'profile', :action =>'index')
	end

	def forgot_post
		tmp = TempPassword.create(:email => params[:forgot_user_email])
		if tmp
			puts tmp.as_json
			UserMailer.reset_password(tmp).deliver
			render 'forgot_confirm'
		else
			flash[:notice] = "There was an error sending the email. Try again later."
			redirect_to :index
		end
		
	end

	def change_password_from_email(uuid)
		tmp = TempPassword.find_by_uuid(uuid)
		@user = User.find_by_email(tmp.email)
	end

	private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
