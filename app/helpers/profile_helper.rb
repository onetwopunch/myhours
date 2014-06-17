module ProfileHelper
  def max_value(category)
    if category.requirement
    	"#{category.requirement} hours #{category.max ? 'max' : 'min'}"
    else
      "N/A"
    end
  end
end
