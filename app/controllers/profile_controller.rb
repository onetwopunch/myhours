class ProfileController < ApplicationController
	# before_filter :redirect_to_login if not session[:user_id]

	def index
		@user = User.find_by_email(session[:user_id])
		unless @user
			redirect_to(:controller => 'login', :action=> 'signup')
      return
		end
    @categories = Category.all
    gon.entries = @user.entry_array
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
	
  #AJAX Methods
  ##########################################################################
  
  def add_entry
    categories = params[:categories] || []
    subcategories = params[:subcategories] || []
    
    @user = User.find_by_email(session[:user_id])
    hours_array = []
    categories.each do |c|
      category = Category.find c[1]['id'].to_i
      hours = c[1]['val'].to_f
      uh = UserHour.new
      uh.category = category
      uh.recorded_hours = hours
      if uh.save
	     	hours_array.push(uh)
      else
        puts uh.errors
      end
    end
    

    subcategories.each do |sc|
      subcategory = Subcategory.find sc[1]['id'].to_i
      hours = sc[1]['val'].to_f
      uh = UserHour.new
      uh.subcategory = subcategory
      uh.recorded_hours = hours
      if uh.save
        hours_array.push(uh)
      else
        puts uh.errors
      end
    end
    
    site = Site.find_by_name(params[:site])
    date = Entry.js_date(params[:date])
    
    entry = Entry.create_entry(@user, site, date, hours_array).skinny
    
    respond_to do |format|
      format.json { render :json => {success: true, entry: entry} }
    end
  end
  
  
  ##########################################################################
  
  
  private
  def user_hours_params(params)
    params.require(:user_hours).permit(:user, :category, :subcategory, :recorded_hours)
  end
end
