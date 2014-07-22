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
      entry.user_hours.find{|uh| uh.category.id == args[:category] }.recorded_hours rescue 0
    elsif args[:subcategory]
      entry.user_hours.find{|uh| uh.subcategory.id == args[:subcategory] }.recorded_hours rescue 0
  	else
    	0
    end      
  end
end
