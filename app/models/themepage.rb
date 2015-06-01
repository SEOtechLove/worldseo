class Themepage < ActiveRecord::Base

 def self.search(search)
	    if search
	      where('url LIKE ?', "%#{search}%")
	    else
	      all
	    end
	  end

def self.to_csv(themepage_items, options = {})
  wanted_columns = [:url, :channel, :h1, :character_count, :title, :title_length, :description, :description_length]
  header = %w(url,channel,h1,count_words,title,title_length,description,description_length)
  CSV.generate do |csv|
    csv << header
    themepage_items.each do |themepage_items|
      attrs = themepage_items.attributes.with_indifferent_access.values_at(*wanted_columns)
      Rails.application.routes.url_helpers.check_theme_page_path(themepage_items.url)
      csv << attrs
    end
  end
end



end
