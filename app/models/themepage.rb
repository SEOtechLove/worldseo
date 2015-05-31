class Themepage < ActiveRecord::Base

 def self.search(search)
	    if search
	      where('url LIKE ?', "%#{search}%")
	    else
	      all
	    end
	  end

def self.to_csv(options = {})
  CSV.generate(options) do |csv|
    csv << column_names
    all.each do |product|
      csv << Themepage.accessible_attributes_theme_page.values_at(*column_names)
    end
  end
end






end
