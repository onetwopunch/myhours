class ProfileController < ApplicationController
  before_filter :redirect_to_login

  def index
    @user = User.find_by_email(session[:user_id])
    unless @user
      redirect_to(:controller => 'login', :action=> 'signup')
      return
    end
    @categories = Category.all
    gon.entries = @user.entry_array
    gon.new_user = !(@user.grad_date && @user.first_name && @user.last_name)
  end

   
  
  #AJAX Methods
  ##########################################################################
  def user_update
    @user = User.find_by_email(session[:user_id])
    if @user
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]
      @user.grad_date = params[:grad_date]
    end
    respond_to do |format|
      format.json { render json: {success: @user.save, errors: @user.errors.messages, entries: @user.entry_array}} 
    end 
  end

  
  def add_site
    @user = User.find_by_email(session[:user_id])
    site = Site.new
    site.name = params[:site_name]
    site.address = params[:site_address]
    site.phone = params[:site_phone]
    

    sup = Supervisor.new
    sup.name = params[:sup_name]
    sup.phone = params[:sup_phone]
    sup.email = params[:sup_email]
    sup.license_type = params[:sup_license_type]
    sup.license_state = params[:sup_license_state]
    sup.license_number = params[:sup_license_number]
    sup.save
    
    site.supervisor = sup
    site.save
    @user.sites << site
    @user.set_default_site(site)

    html = render_to_string(partial: 'all_sites')
    respond_to do |format|
      format.json {render json: {html: html, success: @user.save}}
    end
  end
  
  def get_site
    @user = User.find_by_email(session[:user_id])
    @site = @user.sites.find(params[:site_id])
    puts @site
    html = render_to_string(partial: 'edit_site')
    respond_to do |format|
      format.json { render json: {success: !!@site, html: html}}
    end
  end
  
  def edit_site
    @user = User.find_by_email(session[:user_id])
    site = @user.sites.find(params[:site_id])
    site.name = params[:site_name]
    site.address = params[:site_address]
    site.phone = params[:site_phone]
    
    sup = site.supervisor
    sup.name = params[:sup_name]
    sup.phone = params[:sup_phone]
    sup.email = params[:sup_email]
    sup.license_type = params[:sup_license_type]
    sup.license_state = params[:sup_license_state]
    sup.license_number = params[:sup_license_number]
    sup.save
    
    site.supervisor = sup
    site.save
    @user.sites << site
    @user.set_default_site(site)

    html = render_to_string(partial: 'all_sites')
    respond_to do |format|
      format.json {render json: {html: html, success: @user.save}}
    end
  end
  
  def delete_site 
    @user = User.find_by_email(session[:user_id])
    site = @user.sites.find(params[:site_id])
    success = !!site.destroy
    html = render_to_string(partial: 'all_sites')
    respond_to do |format|
      format.json {render json: {html: html, success: success, errors: site.errors.messages}}
    end
  end
  
  def add_entry
    puts "ADD: #{params.to_json}"
    categories = params[:categories] || []
    subcategories = params[:subcategories] || []
    
    @user = User.find_by_email(session[:user_id])
    puts "USER: #{@user}"
    hours_array = []
    categories.each do |c|
      category = Category.find_by_ref(c[1]['id'].to_i)
      next if c[1]['val'].to_i == 0
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
      subcategory = Subcategory.find_by_ref(sc[1]['id'].to_i)
      next if sc[1]['val'].to_i == 0
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
    
    site = @user.sites.find_by_name(params[:site])
    date = Entry.js_date(params[:date])
    begin
    	entry = Entry.create_entry(@user, site, date, hours_array).skinny
    rescue Exception => e
      respond_to do |format|
        format.json { render :json => {success: false, errors: e.message + e.backtrace.to_s} }
      end
      return
    end
    @user.reload
    progress_html = render_to_string(partial: 'progress')
    puts "ENTRY ARRAY #{@user.entry_array}"
    respond_to do |format|
      format.json { render :json => {success: true, entries: @user.entry_array, progress: progress_html} }
    end
  end
  
  def get_entry
    @entry = Entry.find(params[:entry_id])
    @user = User.find_by_email(session[:user_id])
    @categories = Category.all
    show_html = render_to_string(partial: 'show_entry')
    edit_html = render_to_string(partial: 'edit_entry')
    respond_to do |format|
      format.json {render :json => {show_html: show_html, edit_html: edit_html, success: (!!@entry)}}
    end  
  end
  
  def edit_entry
    puts "EDIT: #{params.to_json}"
    entry = Entry.find(params[:entry_id])
    if entry.destroy 
      add_entry
      return
    else
      respond_to do |format|
        format.json { render :json => {success: false} }
      end
    end     
  end
  
  def delete_entry
    entry = Entry.find(params[:entry_id])
    success = !!entry.destroy
    @user = User.find_by_email(session[:user_id])
    entries = @user.entry_array
    progress_html = render_to_string(partial: 'progress')
    respond_to do |format|
      format.json { render json: {success: success, entries: entries, progress: progress_html} }
    end
  end
  ##########################################################################
  
  
  private
  def user_hours_params(params)
    params.require(:user_hours).permit(:user, :category, :subcategory, :recorded_hours)
  end
end
