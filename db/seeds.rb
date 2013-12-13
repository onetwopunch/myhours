# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(:email=>'jrcanty@gmail.com', :password=>'password')
for i in 0..14
	e = Entry.create(:description=> "JR Description#{i}", 
								:username=> "JR Username#{i}", 
								:password=> "JR_SecretPw#{i}", 
								:user =>user)
end

user2 = User.create(:email=>'katherine@gmail.com', :password=>'password')
for i in 0..6
	e = Entry.create(:description=>" KC Description#{i}", 
										:username=> "KC Username#{i}", 
										:password=> "KC_SecretPw#{i}",
										:user => user2)
end