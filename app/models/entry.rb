# g1 = Category.create name: 'Individual Psychotherapy', is_counselling: true
# g2 = Category.create name: 'Couples, Families, and Children', requirement: 500.0, max: false, is_counselling: true
# g2.subcategories << Subcategory.create( name: 'Conjoint Hours (First 150 hours are double counted)', requirement: 300.0, max: true)

# g3 = Category.create name: 'Group Psychotherapy or Counseling', requirement: 500.0, max: true, is_counselling: true
# g4 = Category.create name: 'Telehealth Counseling, including telephone counseling', requirement: 375.0, max: true, is_counselling: true

# g5 = Category.create name: 'Administrative Tasks', requirement: 500.0, max: true, is_counselling: false
# g5.subcategories << Subcategory.create(name: 'Administrating and evaluating psychological tests', max: true)
# g5.subcategories << Subcategory.create(name: 'Writing Clinical Reports', max: true)
# g5.subcategories << Subcategory.create( name: 'Client Centered Advocacy', max: true)
# g5.subcategories << Subcategory.create(name: 'Writing Progress or Process Notes', max: true)

# g6 = Category.create name: 'Non-Counseling Experience', requirement: 1000.0, max: true, is_counselling: false
# g6.subcategories << Subcategory.create( name: 'Workshops, Seminars, Training Sessions, and Sonferences', requirement: 250.0, max: true)
# g6.subcategories << Subcategory.create( name: 'Personal Psychotherapy (Triple Counted Hours)', requirement: 300.0, max: true)
# g6.subcategories << Subcategory.create( name: 'Direct Supervisor Contact')

class Entry < ActiveRecord::Base
  has_many :user_hours, :dependent => :destroy
  belongs_to :user
  has_one :site 
  
  CAT_INDIVIDUAL 		= 1
  CAT_FAMILIES 			= 2
  CAT_GROUP 			= 3
  CAT_TELEHEALTH 		= 4
  CAT_ADMIN 			= 5
  CAT_NON_COUNSELING 		= 6
  
  SUBCAT_CONJOINT 		= 10
  SUBCAT_PSYCH_TESTS 		= 20
  SUBCAT_REPORTS 		= 30
  SUBCAT_ADVOCACY 		= 40
  SUBCAT_PROCESS_NOTES 		= 50
  SUBCAT_WORKSHOPS 		= 60
  SUBCAT_PERSONAL 		= 70
  SUBCAT_SUPERVISOR 		= 80
  SUBCAT_SUPERVISOR_GROUP	= 90
  
  def hours
    user_hours.select{|u| !u.category.nil? }.map(&:valid_hours).sum
  end
  
  def skinny
    {id: id, title: "#{hours} hours logged", start: date}
  end
  
  def self.js_date(american_date)
    m, d, y = american_date.split('/')
    "#{y}-#{m}-#{d}"
  end
  
  def self.american_date(js_date)
    y, m, d = js_date.split('-')
    "#{m}/#{d}/#{y}"
  end

  def self.create_entry(user, site, date, hours_array)
    validate_grad_date(user, hours_array)
    
    entry = Entry.new 
    entry.user = user
    entry.date = date || Time.new.strftime("%Y-%m-%d")
    entry.site = site || user.default_site
    entry.save
    
    category_hours = hours_array.select{|uh| !!uh.category}
    puts "Cat Hours: #{category_hours.as_json}"
    
    subcategory_hours = hours_array.select{|uh| !!uh.subcategory}
    puts "Subcat Hours: #{subcategory_hours.as_json}"
    
    
    category_hours.each do |cat_hour|
      
      case cat_hour.category.ref
        when CAT_INDIVIDUAL
          puts 'Individual'
          cat_hour.valid_hours = cat_hour.recorded_hours
          if cat_hour.save
            entry.user_hours << cat_hour 
          else
            puts cat_hour.errors
          end
          puts entry.user_hours.as_json

        when CAT_FAMILIES
          cat_hour.valid_hours = cat_hour.recorded_hours
          sc_hour = subcategory_hours.find{|uh| uh.subcategory.ref == SUBCAT_CONJOINT} rescue nil
	  hours = user.hours_per_subcategory(SUBCAT_CONJOINT) + sc_hour.recorded_hours
	  puts "FAM hours = #{hours}"
	  if sc_hour && hours <= sc_hour.subcategory.requirement
            cat_hour.valid_hours += sc_hour.recorded_hours
	    sc_hour.valid_hours = sc_hour.recorded_hours
	  elsif sc_hour 
	    overlap = hours - sc_hour.subcategory.requirement
	    puts "FAM overlap = #{overlap}"
	    sc_hour.valid_hours = sc_hour.recorded_hours - overlap
	    cat_hour.valid_hours += sc_hour.valid_hours
          end
	  cat_hour.recorded_hours += sc_hour.recorded_hours
          entry.user_hours << cat_hour if cat_hour.save
	  entry.user_hours << sc_hour if sc_hour.save

        when CAT_GROUP
	  hours = user.hours_per_category(CAT_GROUP) + cat_hour.recorded_hours 
          unless hours > cat_hour.category.requirement
	    cat_hour.valid_hours = cat_hour.recorded_hours 
          end
          entry.user_hours << cat_hour if cat_hour.save

        when CAT_TELEHEALTH
	  puts "hours_per_category = #{user.hours_per_category(CAT_TELEHEALTH)}"
	  puts "requirement = #{cat_hour.category.requirement}"
	  hours = user.hours_per_category(CAT_TELEHEALTH) + cat_hour.recorded_hours
          unless hours > cat_hour.category.requirement
	    cat_hour.valid_hours = cat_hour.recorded_hours 
          end
          entry.user_hours << cat_hour if cat_hour.save
    	end
      puts "Adding UH #{cat_hour.id} to entry with #{cat_hour.valid_hours} valid hours"
    end
  	
    admin_hours = nil
    non_counseling_hours = nil
    
    subcategory_hours.each do |subcat_hour|
      
      case subcat_hour.subcategory.ref
      when SUBCAT_PSYCH_TESTS, SUBCAT_REPORTS, SUBCAT_ADVOCACY, SUBCAT_PROCESS_NOTES
        unless admin_hours
          puts 'Instantiating admin_hours'
          admin_hours = UserHour.new
          admin_hours.category = Category.find_by_ref(CAT_ADMIN)
          admin_hours.valid_hours = admin_hours.recorded_hours = 0.0
        end
	hours = user.hours_per_category(CAT_ADMIN) + admin_hours.valid_hours + subcat_hour.recorded_hours
	puts "admin_hours = #{hours}"
        unless hours > admin_hours.category.requirement
          admin_hours.recorded_hours += subcat_hour.recorded_hours 
          admin_hours.valid_hours = admin_hours.recorded_hours
	  subcat_hour.valid_hours = subcat_hour.recorded_hours
        end
      when SUBCAT_WORKSHOPS, SUBCAT_PERSONAL, SUBCAT_SUPERVISOR, SUBCAT_SUPERVISOR_GROUP
        unless non_counseling_hours
          non_counseling_hours = UserHour.new
          non_counseling_hours.category = Category.find_by_ref(CAT_NON_COUNSELING)
          non_counseling_hours.valid_hours = non_counseling_hours.recorded_hours = 0.0
        end
	hours = user.hours_per_category(CAT_NON_COUNSELING) + non_counseling_hours.valid_hours + subcat_hour.recorded_hours

        if hours < non_counseling_hours.category.requirement
	  if subcat_hour.subcategory.ref == SUBCAT_PERSONAL
	    total_personal = subcat_hour.recorded_hours * 3 + user.hours_per_subcategory(SUBCAT_PERSONAL)
	    if total_personal > subcat_hour.subcategory.requirement
	      overlap = total_personal - subcat_hour.subcategory.requirement
              non_counseling_hours.recorded_hours += subcat_hour.recorded_hours * 3 - overlap
	      subcat_hour.valid_hours = subcat_hour.recorded_hours * 3 - overlap
	    else
              non_counseling_hours.recorded_hours += subcat_hour.recorded_hours * 3
	      subcat_hour.valid_hours = subcat_hour.recorded_hours * 3
	    end
	  elsif subcat_hour.subcategory.ref == SUBCAT_WORKSHOPS 
	    ws_hours = user.hours_per_subcategory(SUBCAT_WORKSHOPS) + subcat_hour.recorded_hours
	    if ws_hours > subcat_hour.subcategory.requirement
	      overlap = ws_hours - subcat_hour.subcategory.requirement
	      non_counseling_hours.recorded_hours += subcat_hour.recorded_hours - overlap
	      subcat_hour.valid_hours = subcat_hour.recorded_hours - overlap
	    else
	      non_counseling_hours.recorded_hours += subcat_hour.recorded_hours
	      subcat_hour.valid_hours = subcat_hour.recorded_hours
	    end
	  else
	    non_counseling_hours.recorded_hours += subcat_hour.recorded_hours
	    subcat_hour.valid_hours = subcat_hour.recorded_hours
	  end
          non_counseling_hours.valid_hours = non_counseling_hours.recorded_hours
        end
      when SUBCAT_CONJOINT 
       next #skip because we already handled it up top 
      end   
      subcat_hour.save
      entry.user_hours << subcat_hour
    end
    
    entry.user_hours << admin_hours if (admin_hours.save rescue false)
    entry.user_hours << non_counseling_hours if ( non_counseling_hours.save rescue false )
    
    if entry.save
      return entry
    else
      puts entry.errors
      return nil
    end
  end
  
  def self.validate_grad_date(user, hours_array)
    attempted_hours = hours_array.map(&:recorded_hours)
    if Entry.max_before_grad_date_reached(user, attempted_hours)
      raise Exception.new("Pre graduation limit reached. 750 max counseling and supervision + all remaining hours categories = 1,300 max pre-degree hours")
    end
  end
  
  def self.max_before_grad_date_reached(user, attempted)
    today = Time.new.strftime("%Y-%m-%d")
    if today < user.grad_date
      indi_couns = user.hours_per_category(CAT_INDIVIDUAL)
      indi_reached = indi_couns + attempted > 750
      max_reached = user.hours + attempted > 1300
      return indi_reached || max_reached
    end
  end
end
