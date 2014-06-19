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
  has_many :user_hours
  belongs_to :user
  has_many :categories, through: :user_hours
  
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
  
  #TODO: Write a unit test in rspec for this :)
  def self.create_entry(user, hours_array)
    entry = Entry.new    
    
    category_hours = hours_array.map{|uh| uh if uh.category}
    puts category_hours
    
    subcategory_hours = hours_array.map{|uh| uh if uh.subcategory}
    puts subcategory_hours
    
    category_hours.each do |cat_hour|
      switch cat_hour.id
        when CAT_INDIVIDUAL
          cat_hour.valid_hours = cat_hour.recorded_hours 
          entry.user_hours << cat_hour.save

        when CAT_FAMILIES
          cat_hour.valid_hours = cat_hour.recorded_hours
          if sc = subcategory_hours.detect{|uh| uh.subcategory.id == SUBCAT_CONJOINT}
             cat_hour.valid_hours + sc.recorded_hours
          end
          entry.user_hours << cat_hour.save

        when CAT_GROUP
          cat_hour.valid_hours = cat_hour.recorded_hours unless user.hours_per_category(CAT_GROUP) >= cat_hour.category.requirement
          entry.user_hours << cat_hour.save

        when CAT_TELEHEALTH
          cat_hour.valid_hours = cat_hour.recorded_hours unless user.hours_per_category(CAT_TELEHEALTH) >= cat_hour.category.requirement
          entry.user_hours << cat_hour.save
    	end
    end
  
    subcategory_hours.each do |subcat_hour|
      admin_hours = nil
      non_counseling_hours = nil
      switch subcat_hour.id
        when SUBCAT_PSYCH_TESTS, SUBCAT_REPORTS, SUBCAT_ADVOCACY, SUBCAT_PROCESS_NOTES
          unless admin_hours
            admin_hours = UserHours.new
            admin_hours.category_id = CAT_ADMIN
          end
          admin_hours.valid_hours = subcat_hour.recorded_hours unless user.hours_per_category(CAT_ADMIN) >= admin_hours.category.requirement

        when SUBCAT_WORKSHOPS, SUBCAT_PERSONAL, SUBCAT_SUPERVISOR
          unless admin_hours
            admin_hours = UserHours.new
            admin_hours.category_id = CAT_NON_COUNSELING
          end
          non_counseling_hours.valid_hours = subcat_hour.recorded_hours unless user.hours_per_category(CAT_NON_COUNSELING) >= non_counseling_hours.category.requirement
    	end
    end
  end
end
