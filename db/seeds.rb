Category.attr_accessible :name, :is_counseling, :requirement, :max
Subcategory.attr_accessible :name, :category, :requirement, :max

g1 = Category.create name: 'Individual Psychotherapy', is_counselling: true
g2 = Category.create name: 'Couples, Families, and Children', requirement: 500.0, max: false, is_counselling: true
Subcategory.create name: 'Conjoint Hours (First 150 hours are double counted)', categories_id: g2.id, requirement: 300.0, max: true

g3 = Category.create name: 'Group Psychotherapy or Counseling', requirement: 500.0, max: true, is_counselling: true
g4 = Category.create name: 'Telehealth Counseling, including telephone counseling', requirement: 375.0, max: true, is_counselling: true

g5 = Category.create name: 'Administrative Tasks', requirement: 500.0, max: true, is_counselling: false
Subcategory.create name: 'Administrating and evaluating psychological tests', categories_id: g5.id, max: true
Subcategory.create name: 'Writing Clinical Reports', categories_id: g5.id, max: true
Subcategory.create name: 'Client Centered Advocacy', categories_id: g5.id, max: true
Subcategory.create name: 'Writing Progress or Process Notes', categories_id: g5.id, max: true

g6 = Category.create name: 'Non-Counseling Experience', requirement: 1000.0, max: true, is_counselling: false
Subcategory.create name: 'Workshops, Seminars, Training Sessions, and Sonferences', requirement: 250.0, categories_id: g6.id, max: true
Subcategory.create name: 'Personal Psychotherapy (Triple Counted Hours)', requirement: 300.0, categories_id: g6.id, max: true
Subcategory.create name: 'Direct Supervisor Contact', categories_id: g6.id




