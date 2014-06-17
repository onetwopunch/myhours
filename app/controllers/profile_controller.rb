#TODO: Download a user's data to localStorage so they can access it offline

class ProfileController < ApplicationController
	# before_filter :redirect_to_login if not session[:user_id]

	def index
		@user = User.find_by_email(session[:user_id])
		unless @user
			redirect_to(:controller => 'login', :action=> 'signup')
		end
    @categories = Category.all
	end
	
  def add_entry
    
  end
  
  def user_update
    @user = User.find_by_email(session[:user_id])
    if @user
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]
      @user.grad_date = params[:grad_date]
      @user.save
    end
    redirect_to :back
  end

end
