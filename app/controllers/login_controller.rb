class LoginController < ApplicationController
  before_filter :redirect_to_profile, only: [:index, :signup]
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
				flash[:notice] = "Email/Password combination are incorrect."
				redirect_to(:action =>'index')
			end
		end
	end

	def check_email_exists
		email = params[:email]
		user = User.find_by_email(email)		
		respond_to do |format|	
			if user
				puts 'User exisits'
	   		format.json { render :json => {:response => "user_exists"} }
			else
				puts 'User does not exisit'
	   		format.json { render :json => {:response => "user_not_exists"} }
	   	end
   	end 
	end


	def logout
		session[:user_id] = nil
    redirect_to :action => 'index'
	end

	def signup 
		@user = User.new
	end
	
	def create
		user = User.create(user_params)
		if user.valid?
			session[:user_id] = user.email
			redirect_to(:controller=>'profile', :action =>'index')
		else
			flash[:notice] = "There was an error creating your account. Please try again."
			redirect_to(:action => 'signup')
		end
	end

	def update
		user = User.find_by_email(params[:email])
		unhashed = params[:user_password]
		user.password = unhashed # will be hashed after save
		
		unless user.save
			puts "Update save failed"
		end
		new_user = User.authenticate(user.email, unhashed)
		if new_user
			session[:user_id] = new_user.email
			destroyed = TempPassword.destroy_all(:email => new_user.email)
			puts destroyed.length.to_s + " temp passwords destroyed"
			redirect_to(:controller=>'profile', :action =>'index')
		else 
			puts "User auth failed after update"
			redirect_to(:action =>'index')
		end
	end

	def forgot_post
		user = User.find_by_email(params[:forgot_user_email])
		if user
			tmp = TempPassword.create(:email => params[:forgot_user_email])
			if tmp
				puts tmp.as_json
				UserMailer.reset_password(tmp).deliver
				redirect_to :action =>'forgot_confirm'
			else
				flash[:notice] = "There was an error sending the email. Try again later."
				redirect_to :action => 'index'
			end
		else
			redirect_to :action => 'forgot'
		end
	end

	def change_password_from_email
		puts params[:guid]
		@tmp = TempPassword.validate_password(params[:guid])
		if @tmp
			render 'change_password'
		else
			redirect_to(:action =>'index')
		end
	end


	private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
