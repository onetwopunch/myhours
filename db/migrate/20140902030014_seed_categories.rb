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
      g5.name = 'Administering & evaluating psychogical tests, writing clinical reposrts, writing progress or process notes'
      g5.requirement =  250.0 
      g5.max =  true 
      g5.is_counselling = false
      g5.ref = 5
      g5.save
    end
    
    ###########################################
    unless Category.find_by_ref(6)
      g6 = Category.new
      g6.name = 'Workshops, Seminars, Training Sessions, and Conferences directly related to marriage, family and child counselling'
      g6.ref = 6
      g6.max = true
      g6.requirement = 250.0
      g6.is_counselling = false
      g6.save
    end
    
    ###########################################
    
    unless Category.find_by_ref(7)
      g7 = Category.new 
      g7.name =  'Non-Counseling Experience' 
      g7.requirement =  1250.0
      g7.max =  true  
      g7.is_counselling = false
      g7.ref = 7

      sc20 = Subcategory.new
      sc20.name = 'Personal Psychotherapy (Triple-Counted Hours)'
      sc20.requirement = 300.0
      sc20.max = true
      sc20.ref = 20
      sc20.save

      sc30 = Subcategory.new
      sc30.name = 'Individual Supervision'
      sc30.ref = 30
      sc30.save
      
      sc40 = Subcategory.new
      sc40.name = 'Group Supervision'
      sc40.ref = 40
      sc40.save 

      sc50 =  Subcategory.new
      sc50.name = 'Client Centered Advocacy (CCA)'
      sc50.ref = 50
      sc50.save

      g7.subcategories << sc20
      g7.subcategories << sc30
      g7.subcategories << sc40
      g7.subcategories << sc50

      g7.save
    end
  end

  def down
    Category.delete_all
    Subcategory.delete_all
  end
end
