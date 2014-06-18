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
    @user = User.find_by_email(session[:user_id])
    hours_array = []
    params[:categories].each do |c|
      category = Category.find c[1]['id'].to_i
      hours = c[1]['val'].to_f
      uh = UserHours.new
      uh.category = category
      uh.recorded_hours = hours
      if uh.save
	     	hours_array.push(uh)
      else
        puts uh.errors
      end
    end
    
    params[:subcategories].each do |sc|
      subcategory = Subcategory.find sc[1]['id'].to_i
      hours = sc[1]['val'].to_f
      uh = UserHours.new
      uh.subcategory = subcategory
      uh.recorded_hours = hours
      if uh.save
        hours_array.push(uh)
      else
        puts uh.errors
      end
    end
    
    entry = Entry.create_entry(@user, hours_array)
    
    respond_to do |format|
      format.json { render :json => {success: true, entry: entry} }
    end
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

  private
  def user_hours_params(params)
    params.require(:user_hours).permit(:user, :category, :subcategory, :recorded_hours)
  end
end
