require 'uuid'
require 'digest/sha1'


class User < ActiveRecord::Base
	# attr_accessor :email, :password, :entry_hash
	has_many :entries
  has_many :sites
  before_save :create_hashed_password, if: :password_changed?
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

  validates :email, :presence => true, :length => { :within => 5..100 }, 
	  :format=>EMAIL_REGEX, :confirmation => true, :uniqueness=>true
  validates :password, :presence => true

  def self.authenticate(email='', password = '')
    user = User.find_by_email( email)
    if user && user.password == get_hashed_password(password)
      return user
    else
      return false
    end
  end
  
  def self.get_hashed_password(password="")
    if password != nil
      Digest::SHA1.hexdigest(password)
    else 
      puts 'fail'
    end
  end

  def self.make_salt
    UUID.state_file = false
    UUID.generator.next_sequence
    UUID.new.generate
  end

  def create_hashed_password
    unless password.blank?
      self.salt ||= User.make_salt
      self.password = User.get_hashed_password(password)
    end		
  end
  
  def self.find_by_token(token)
    User.find{|u| u.private_token == token}
  end

  def private_token
    Digest::SHA1.hexdigest(salt)
  end
  
  def hours_per_category(category_ref)
    return 0 if entries.count == 0
    count = 0
    entries.each do |entry|
      cats = entry.user_hours.select{ |uh| uh.category }
      matching_cat = cats.find{|uh| uh.category.ref == category_ref }
      count += matching_cat.valid_hours if matching_cat
    end 
    return count
  end
 
  def hours_per_subcategory(sc_ref)
    return 0 if entries.count == 0
    count = 0
    entries.each do |entry|
      subcats = entry.user_hours.select{ |uh| uh.subcategory }
      matching_subcat = subcats.find{|uh| uh.subcategory.ref == sc_ref }
      count += matching_subcat.valid_hours if matching_subcat
    end
    return count
  end


  def entry_array
    result = []
    result << {id: -1, title: 'Graduation Date', start: grad_date, color: 'red'} if grad_date
    entries.each do |e|
      result << {id: e.id, title: "#{e.hours} hours logged", start: e.date}
    end
    result
  end
  
  def default_site
    res = sites.select{|s| s.is_default_site == true}
    if res.count > 0 
      res.first
    else
      nil
    end
  end
  
  def set_default_site(site)
    d = default_site
    if d and d != site
      d.is_default_site = false
      d.save
    end
    site.is_default_site = true
    site.save
    
  end 
  
  def hours
    entries.map{|e| e.hours }.sum
  end
  
  def totals_between(s, e)
    start_date = Entry.js_date(s)
    end_date = Entry.js_date(e)
    selected_entries = entries.select{ |e| e.date >= start_date && e.date <= end_date }
    totals = { valid_sum: 0, recorded_sum: 0, recorded_hours: Hash.new(0), valid_hours: Hash.new(0) }
    selected_entries.each do |entry|
      entry.user_hours.each do |uh|
	ref = uh.category.ref rescue uh.subcategory.ref
      	totals[:recorded_hours][ref] += uh.recorded_hours
	totals[:valid_hours][ref] += uh.valid_hours
	totals[:recorded_sum] += uh.recorded_hours
	totals[:valid_sum] += uh.valid_hours
      end
    end
    return totals
  end
  
  def progress
    '%.2f' % ((hours / 3000) * 100)
  end    
end
