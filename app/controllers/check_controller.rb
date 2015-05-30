class CheckController < ApplicationController
		helper_method :sort_column_theme, :sort_column_article, :sort_direction

		def theme_page
			@themepage_items = Themepage.search(params[:search]).order(sort_column_theme + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])
			@theme_count = get_count_theme_page
			@theme_without_text = get_theme_page_without_text
			#update_theme_page_check
			#add_breadcrumb "Themepage", :check
		end

 		def article_page
	  		@articlepage_items = Articlepage.search(params[:search]).order(sort_column_article + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])
	  		@article_count = get_count_article_page
	  		@article_without_seo = get_article_page_without_seo_title
	  	end

	  	

	  	def update_theme_page_check
	   	  	#themen_ordner = ["0", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
		    themen_ordner = ["q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
		    themen_ordner.each do |alfa|
		       html_doc = Nokogiri::HTML(open("http://www.welt.de/themen/#{alfa}"))
		       begin
		       		url_link = html_doc.xpath("//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'atozlist', ' ' ))]//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'content', ' ' ))]//a['href=']").map { |link| link['href'] }
		       rescue
		       		next
	           end
		       url_link.each_with_index do |element, index|
		           element_new = URI.parse(URI.encode(element.strip)) 
		           begin
		           doc = Nokogiri::HTML(open(element_new))    
		           rescue
		           		next
		           end
		           content_set = doc.xpath("//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'themeBodyText', ' ' ))]").text
		           channel = doc.xpath("//*[(@id = 'header')]//div[(((count(preceding-sibling::*) + 1) = 2) and parent::*)]//span").text
		           title = doc.xpath('//html/head/title').text 
   				   title_count = title.length
   				   description = doc.xpath('//head/meta[@name = "description"]/@content').text 
   				   description_count = description.length
		           if content_set.to_s.strip.length == 0
		           		begin
		                 store_as_themepage(element, channel, 0, title, title_count, description, description_count)
		               end
		           else 
		               content_set = content_set.strip
		               count_words = content_set.length
		               begin
		               	store_as_themepage(element, channel, count_words, title, title_count, description, description_count)
		           	   end
		           end
		     	 end
		  	 end 
		  	 @get_actual_date = get_actual_date
	  	end		

	  	def update_article_page_check
	  	channels = ["debatte", "fernsehen", "geschichte", "gesundheit", "icon", "kultur", "motor", "politik", "reise", "satire", "sport", "vermischtes", "wirtschaft", "wissenschaft"] 
   		home = "http://www.welt.de/"
   		channels.each do |alfa|
   			channel_root = "http://www.welt.de/#{alfa}/"
		    xml_url = channel_root +'?service=Rss'
		    begin
		    xml_doc = Nokogiri::XML(open(xml_url ,"User-Agent" => "Ruby/#{RUBY_VERSION}"))
		    rescue
		    	next
		    end
		    url_link = xml_doc.xpath("//link")
		    url_link = url_link.reverse
      		url_link.each do |element|
	           url_at = url_link.pop
	           url = url_at.text
	           if url == channel_root or url == home
	              next
	           end
	           begin
           	   doc = Nokogiri::HTML(open(url ,"User-Agent" => "Ruby/#{RUBY_VERSION}"))
	           rescue
	           	 next
	           end
	           #Auslesen Meta-Tags
	           title_source = doc.xpath('//html/head/title').text 
	           title_count = title_source.length
	           begin
	           		kicker = doc.xpath("//h2").first.text 
	           rescue
	           		kicker = nil
	           end
	           title = title_source.split(" - DIE WELT")
	           title = title.join("")
	           channel = doc.xpath("//*[(@id = 'header')]//div[(((count(preceding-sibling::*) + 1) = 2) and parent::*)]//span").text
	           title = title.strip
	           description = doc.xpath('//head/meta[@name = "description"]/@content').text 
	           description_count = description.length
	           h1 = doc.xpath("/html/body//h1").text.strip
	           h1_kicker = "#{kicker}: "+"#{h1}"
	           if h1_kicker == title
	              	store_as_articlepage(url, channel, false, title, title_count, description, description_count, kicker, h1)
	           else 
	            	store_as_articlepage(url, channel, true, title, title_count, description, description_count, kicker, h1)
	           end
     		end
   		end
   		@get_actual_date = get_actual_date
	  end

	  private
	  
	  def store_as_themepage(url, channel, count_words, title, title_length, description, description_length)
	  	if (Themepage.find_by_url(url) == nil)
	  		Themepage.create(:url => url, :channel => channel, :character_count => count_words, :title => title, :title_length => title_length, :description => description, :description_length => description_length)
	  	else 
	  		Themepage.find_by_url(url).delete 
	  		Themepage.create(:url => url, :channel => channel, :character_count => count_words, :title => title, :title_length => title_length, :description => description, :description_length => description_length)
	  	end
	  end

	  def store_as_articlepage(url, channel, is_seotitle, title, title_length, description, description_length, kicker, h1)
	  	if (Articlepage.find_by_url(url) == nil)
	  		Articlepage.create(:url => url, :channel => channel, :is_seotitle => is_seotitle, :title => title, :title_length => title_length, :description => description, :description_length => description_length, :kicker => kicker, :h1 => h1)
	  	else 
	  		Articlepage.find_by_url(url).delete 
	  		Articlepage.create(:url => url, :channel => channel, :is_seotitle => is_seotitle, :title => title, :title_length => title_length, :description => description, :description_length => description_length, :kicker => kicker, :h1 => h1)
	  	end
	  end

	  def get_article_page_without_seo_title
	  	Articlepage.where(is_seotitle: false).count
	  end

	  def get_theme_page_without_text
	  	Themepage.where(character_count: '0').count
	  end

	  def get_count_theme_page
			Themepage.count
	  end

	  def get_count_article_page
			Articlepage.count
	  end

	  def get_actual_date
	  		@get_actual_date = Time.now
	  end

	  def sort_column_theme
	    Themepage.column_names.include?(params[:sort]) ? params[:sort] : "url"
	  end
	  
	  def sort_direction
	    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
	  end

	  def sort_column_article
	    Articlepage.column_names.include?(params[:sort]) ? params[:sort] : "url"
	  end

	  
end


