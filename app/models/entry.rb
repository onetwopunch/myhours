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
  
  CAT_INDIVIDUAL 				= 1
  CAT_FAMILIES 					= 2
  CAT_GROUP 						= 3
  CAT_TELEHEALTH 				= 4
  CAT_ADMIN 						= 5
  CAT_NON_COUNSELING 		= 6
  
  SUBCAT_CONJOINT 			= 1
  SUBCAT_PSYCH_TESTS 		= 2
  SUBCAT_REPORTS 				= 3
  SUBCAT_ADVOCACY 			= 4
  SUBCAT_PROCESS_NOTES 	= 5
  SUBCAT_WORKSHOPS 			= 6
  SUBCAT_PERSONAL 			= 7
  SUBCAT_SUPERVISOR 		= 8
  
  def hours
    user_hours.map(&:valid_hours).sum
  end
  
  def skinny
    {id: id, title: "#{hours} hours logged", start: date}
  end
  
  def self.js_date(american_date)
    m, d, y = american_date.split('/')
    "#{y}-#{m}-#{d}"
  end
    
  def self.create_entry(user, site, date, hours_array)
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
      
      case cat_hour.category_id
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
        	sc = subcategory_hours.find{|uh| uh.subcategory.id == SUBCAT_CONJOINT} rescue nil
          if sc
             cat_hour.valid_hours += sc.recorded_hours
          end
          entry.user_hours << cat_hour if cat_hour.save

        when CAT_GROUP
        	unless user.hours_per_category(CAT_GROUP) >= cat_hour.category.requirement
	          cat_hour.valid_hours = cat_hour.recorded_hours 
          end
          entry.user_hours << cat_hour if cat_hour.save

        when CAT_TELEHEALTH
        	unless user.hours_per_category(CAT_TELEHEALTH) >= cat_hour.category.requirement
	          cat_hour.valid_hours = cat_hour.recorded_hours 
          end
          entry.user_hours << cat_hour if cat_hour.save
    	end
      puts "Adding UH #{cat_hour.id} to entry with #{cat_hour.valid_hours} valid hours"
    end
  	
    admin_hours = nil
    non_counseling_hours = nil
    
    subcategory_hours.each do |subcat_hour|
      
      case subcat_hour.subcategory_id
        when SUBCAT_PSYCH_TESTS, SUBCAT_REPORTS, SUBCAT_ADVOCACY, SUBCAT_PROCESS_NOTES
          unless admin_hours
            puts 'Instantiating admin_hours'
            admin_hours = UserHour.new
            admin_hours.category_id = CAT_ADMIN
            admin_hours.valid_hours = admin_hours.recorded_hours = 0.0
          end
          unless user.hours_per_category(CAT_ADMIN) >= admin_hours.category.requirement
            admin_hours.recorded_hours += subcat_hour.recorded_hours 
            admin_hours.valid_hours = admin_hours.recorded_hours
          end
        	
        when SUBCAT_WORKSHOPS, SUBCAT_PERSONAL, SUBCAT_SUPERVISOR
          unless non_counseling_hours
            non_counseling_hours = UserHour.new
            non_counseling_hours.category_id = CAT_NON_COUNSELING
            non_counseling_hours.valid_hours = non_counseling_hours.recorded_hours = 0.0
          end
        	
        	unless user.hours_per_category(CAT_NON_COUNSELING) >= non_counseling_hours.category.requirement
            non_counseling_hours.recorded_hours += subcat_hour.recorded_hours 
            non_counseling_hours.valid_hours = non_counseling_hours.recorded_hours
          end
        	
    	end    
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
end
