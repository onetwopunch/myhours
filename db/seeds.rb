Category.attr_accessible :name, :is_counseling, :requirement, :max
Subcategory.attr_accessible :name, :category, :requirement, :max

g1 = Category.create name: 'Individual Psychotherapy', is_counselling: true
g2 = Category.create name: 'Couples, Families, and Children', requirement: 500.0, max: false, is_counselling: true
g2.subcategories << Subcategory.create( name: 'Conjoint Hours (First 150 hours are double counted)', requirement: 300.0, max: true)

g3 = Category.create name: 'Group Psychotherapy or Counseling', requirement: 500.0, max: true, is_counselling: true
g4 = Category.create name: 'Telehealth Counseling, including telephone counseling', requirement: 375.0, max: true, is_counselling: true

g5 = Category.create name: 'Administrative Tasks', requirement: 500.0, max: true, is_counselling: false
g5.subcategories << Subcategory.create(name: 'Administrating and evaluating psychological tests', max: true)
g5.subcategories << Subcategory.create(name: 'Writing Clinical Reports', max: true)
g5.subcategories << Subcategory.create( name: 'Client Centered Advocacy', max: true)
g5.subcategories << Subcategory.create(name: 'Writing Progress or Process Notes', max: true)

g6 = Category.create name: 'Non-Counseling Experience', requirement: 1000.0, max: true, is_counselling: false
g6.subcategories << Subcategory.create( name: 'Workshops, Seminars, Training Sessions, and Sonferences', requirement: 250.0, max: true)
g6.subcategories << Subcategory.create( name: 'Personal Psychotherapy (Triple Counted Hours)', requirement: 300.0, max: true)
g6.subcategories << Subcategory.create( name: 'Direct Supervisor Contact')




