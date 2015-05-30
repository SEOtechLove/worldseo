class VisibilityController < ApplicationController
  	
  	def index

 	end

 	def searchmetrics_page

 	end

  	def sistrix_page
  		domain = "http://www.welt.de/themen/"
		api_key = "2QJTp3HNTkuqBZhcMPrayBQkdFpFQh87"
  	end


	def get_sistrix_keyword_count(domain, api_key)
		url = "http://api.sistrix.net/domain.kwcount.seo?api_key=#{api_key}&path=#{domain}"
		doc = Nokogiri::XML(open(url))
		kwcount = doc.xpath("//response/answer/kwcount.seo/@value")
		puts "Anzahl Keywords von #{domain}: #{kwcount}"
	end


	def get_sistrix_sichtbarkeitsindex(domain, api_key)
		url = "http://api.sistrix.net/domain.sichtbarkeitsindex?api_key=#{api_key}&path=#{domain}"
		doc = Nokogiri::XML(open(url))
		sbi = doc.xpath("//response/answer/sichtbarkeitsindex/@value")
		puts "Sichtbarkeitsindex von #{domain}: #{sbi}"
	end

	def get_sistrix_anzahl_keyword_domains_1_to_10(domain, api_key)
		url = "http://api.sistrix.net/keyword.domain.seo?api_key=$#{api_key}&domain=#{domain}/themen&dfrom_pos=1?to_pos=10"
	end



  def analyze
    keyword = params[:keyword]   
    @view_hash = {}
    keyword_hash = {}
    serps = scrape_serps(keyword)
    #Berechnung des ni pro Keyword - Anzahl der Urls, die das Keyword verwenden
    keywords_nis = keyword_counter_hash(keyword, serps)
    
    index = 1
    
    serps.each do |url|
    content_hash = get_content(url)
      
    content_hash['keywords'] = analyze_content(content_hash[:result_text], content_hash[:count], keywords_nis)
    content_hash['index'] = index
      
    gon_ausgabe(index, content_hash['keywords'])
   
    index = index + 1
      @view_hash[url.to_s] = content_hash
    end 
    
    index = 1
    
    render :index  
  end 
end
