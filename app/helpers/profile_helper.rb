module ProfileHelper
  def max_value(category)
    if category.requirement
    	"#{category.requirement} hours #{category.max ? 'max' : 'min'}"
    else
      "N/A"
    end
  end
  
  def recorded_hours(entry, **args)
  	if args[:category]
      entry.user_hours.find{|uh| uh.category.ref == args[:category] }.recorded_hours rescue 0
    elsif args[:subcategory]
      entry.user_hours.find{|uh| uh.subcategory.ref == args[:subcategory] }.recorded_hours rescue 0
  	else
    	0
    end      
  end
  def user_progress
    res =  @user.progress 
    if res >= 100
      res = 100
    else
      res
    end
  end
end
