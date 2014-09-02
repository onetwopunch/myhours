class SeedCategories < ActiveRecord::Migration
  def up
    
    ###########################################
    unless Category.find_by_ref(1)
      g1 = Category.new
      g1.name = 'Individual Psychotherapy'
      g1.is_counselling = true
      g1.ref = 1
      g1.save
    end
    ###########################################

    unless Category.find_by_ref(2)
      g2 = Category.new 
      g2.name = 'Couples, Families, and Children'
      g2.requirement =  500.0
      g2.max = false
      g2.is_counselling =  true
      g2.ref = 2

      sc10 = Subcategory.new
      sc10.name = 'Of the above CFC hours, how many were conjoint couples and family therapy?'
      sc10.requirement = 150.0
      sc10.max = true
      sc10.ref = 10
      sc10.save

      g2.subcategories << sc10
      g2.save
    end
    
    ###########################################
    unless Category.find_by_ref(3)
      g3 = Category.new 
      g3.name = 'Group Psychotherapy or Counseling' 
      g3.requirement= 500.0 
      g3.max= true 
      g3.is_counselling = true
      g3.ref = 3
      g3.save
    end
    ###########################################

    unless Category.find_by_ref(4)
      g4 = Category.new 
      g4.name = 'Telehealth Counseling, including telephone counseling' 
      g4.requirement = 375.0  
      g4.max = true 
      g4.is_counselling = true
      g4.ref = 4
      g4.save
    end

    ###########################################
    
    unless Category.find_by_ref(5)
      g5 = Category.new 
      g5.name = 'Administrative Tasks'
      g5.requirement =  500.0 
      g5.max =  true 
      g5.is_counselling = false
      g5.ref = 5

      sc20 = Subcategory.new
      sc20.name = 'Administrating and evaluating psychological tests'
      sc20.max = true
      sc20.ref = 20
      sc20.save

      sc30 = Subcategory.new
      sc30.name =  'Writing Clinical Reports'
      sc30.max = true
      sc30.ref = 30
      sc30.save

      sc40 = Subcategory.new
      sc40.name = 'Client Centered Advocacy'
      sc40.max = true
      sc40.ref = 40
      sc40.save

      sc50 = Subcategory.new
      sc50.name = 'Writing Progress or Process Notes'
      sc50.max = true
      sc50.ref = 50
      sc50.save

      g5.subcategories << sc20
      g5.subcategories << sc30
      g5.subcategories << sc40
      g5.subcategories << sc50

      g5.save
    end
    ###########################################
    unless Category.find_by_ref(6)
      g6 = Category.new 
      g6.name =  'Non-Counseling Experience' 
      g6.requirement =  1000.0
      g6.max =  true  
      g6.is_counselling = false
      g6.ref = 6

      sc60 = Subcategory.new
      sc60.name = 'Workshops, Seminars, Training Sessions, and Sonferences'
      sc60.requirement = 250.0
      sc60.max = true
      sc60.ref = 60
      sc60.save

      sc70 = Subcategory.new
      sc70.name = 'Personal Psychotherapy (Triple-Counted Hours)'
      sc70.requirement = 300.0
      sc70.max = true
      sc70.ref = 70
      sc70.save

      sc80 = Subcategory.new
      sc80.name = 'Individual Supervision'
      sc80.ref = 80
      sc80.save
      
      sc90 = Subcategory.new
      sc90.name = 'Group Supervision'
      sc90.ref = 90
      sc90.save 

      g6.subcategories << sc60
      g6.subcategories << sc70
      g6.subcategories << sc80
      g6.subcategories << sc90

      g6.save
    end
  end

  def down
    Category.delete_all
    Subcategory.delete_all
  end
end
