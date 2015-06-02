class VisibilityController < ApplicationController
  	helper_method :sort_column_visibility, :sort_direction
  def index

 	end

 	def searchmetrics_page

 	end

  def sistrix_page
      #get_sistrix_visibility_per_folder(get_sistrix_api_key)
      @sistrix_items = SistrixVisibilityIndex.order(sort_column_visibility + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])
      @sistrix_items_all = SistrixVisibilityIndex.all

      
      
  end

  private 
  
	def get_sistrix_keyword_count(domain, api_key)
		  url = "http://api.sistrix.net/domain.kwcount.seo?api_key=#{api_key}&path=#{domain}"
		  doc = Nokogiri::XML(open(url))
		  kwcount = doc.xpath("//response/answer/kwcount.seo/@value")
      return kwcount
	end


	def get_sistrix_visibility_index(domain, api_key)
		  url = "http://api.sistrix.net/domain.sichtbarkeitsindex?api_key=#{api_key}&path=#{domain}"
		  doc = Nokogiri::XML(open(url))
		  sbi = doc.xpath("//response/answer/sichtbarkeitsindex/@value")
      return sbi
	end


  def get_sistrix_visibility_per_folder(api_key)
      home = "http://www.welt.de/"
      channels = ["http://www.welt.de/", "http://www.welt.de/themen/", "http://www.welt.de/debatte", "http://www.welt.de/fernsehen/", "http://www.welt.de/geschichte/", "http://www.welt.de/gesundheit/", "http://www.welt.de/icon/", "http://www.welt.de/kultur/", "http://www.welt.de/motor/", "http://www.welt.de/politik/", "http://www.welt.de/reise/", "http://www.welt.de/satire/", "http://www.welt.de/sport", "http://www.welt.de/vermischtes", "http://www.welt.de/wirtschaft/", "http://www.welt.de/wissenschaft/"] 
      channels.each do |t|
      sistrix_index = get_sistrix_visibility_index(t, api_key)
      channel = get_channel(t)
      kw = get_calendar_week
        begin
          store_sistrix_visibility_indices(t, channel, kw, sistrix_index)
        end
      end
  end

  def get_channel(url)
      return url
      #implement channel
  end

  def get_calendar_week
      return Time.now.strftime("%W").to_i
  end

  def store_sistrix_visibility_indices(url, channel, kw, sistrix_index)
        if (SistrixVisibilityIndex.find_by_url(url) == nil)
          SistrixVisibilityIndex.create(:url => url, :channel => channel, :kw => kw, :sistrix_index => sistrix_index)
        else 
          SistrixVisibilityIndex.find_by_url(url).delete 
          SistrixVisibilityIndex.create(:url => url, :channel => channel, :kw => kw, :sistrix_index => sistrix_index)
        end
  end

  def get_sistrix_api_key
      return "2QJTp3HNTkuqBZhcMPrayBQkdFpFQh87"
  end

  def sort_column_visibility
      SistrixVisibilityIndex.column_names.include?(params[:sort]) ? params[:sort] : "url"
  end
    
  def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end



end


