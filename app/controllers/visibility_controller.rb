class VisibilityController < ApplicationController
  	helper_method :sort_column_visibility, :sort_direction
  def index

 	end

 	def searchmetrics_page
     @searchmetrics_items_all = SearchmetricsIndex.all  
 	end

  def sistrix_page
      #get_sistrix_visibility_per_channel_history(get_sistrix_api_key)
      get_sistrix_visibility_per_channel(get_sistrix_api_key)
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
		  svi = doc.xpath("//response/answer/sichtbarkeitsindex/@value")
        date = doc.xpath("//response/answer/sichtbarkeitsindex/@date").text
        return svi,date
	end
    
    def get_sistrix_visibility_index_per_date(domain, api_key, date)
		  url = "http://api.sistrix.net/domain.sichtbarkeitsindex?api_key=#{api_key}&path=#{domain}?history=true?date=#{date}"
		  doc = Nokogiri::XML(open(url))
		  svi = doc.xpath("//response/answer/sichtbarkeitsindex/@value")
      return svi
	end    
    
    def get_sistrix_visibility_per_channel_history(api_key)
        channels = get_channels
        date = get_dates
        channels.each do |c|
            date.each do |date|
                sistrix_index = get_sistrix_visibility_index_per_date(c, api_key, date)
                channel = get_channel(c)
                kw = date
                begin
                  store_sistrix_visibility_indices(c, channel, kw, sistrix_index)
                end
            end
        end
  end
    
    def get_channels
         channels = ["http://www.welt.de/", "http://www.welt.de/themen/", "http://www.welt.de/debatte", "http://www.welt.de/fernsehen/", "http://www.welt.de/geschichte/", "http://www.welt.de/gesundheit/", "http://www.welt.de/icon/", "http://www.welt.de/kultur/", "http://www.welt.de/motor/", "http://www.welt.de/politik/", "http://www.welt.de/reise/", "http://www.welt.de/satire/", "http://www.welt.de/sport", "http://www.welt.de/vermischtes", "http://www.welt.de/wirtschaft/", "http://www.welt.de/wissenschaft/"] 
        return channels
    end
    
    def get_dates
        dates = ["2015-06-01", "2015-05-25", "2015-05-18", "2015-05-11", "2015-05-04", "2015-04-27", "2015-04-20", "2015-04-13", "2015-04-06T00:00:00+02:00", "2015-03-30T00:00:00+02:00", "2015-03-23T00:00:00+01:00", "2015-03-16", "2015-03-09", "2015-03-02", "2015-02-23", "2015-02-16", "2015-02-09", "2015-02-02", "2015-01-26", "2015-01-19", "2015-01-12", "2015-01-05"]
        return dates
    end
    
    
    def get_sistrix_visibility_per_channel(api_key)
         channels = get_channels
        channels.each do |c|
            sistrix_index, date = get_sistrix_visibility_index(c, api_key)
            channel = get_channel(c)
            kw = date
        begin
            store_sistrix_visibility_indices(c, channel, kw, sistrix_index)
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
          
    elsif (SistrixVisibilityIndex.find_by_url_and_kw(url, kw) == nil)
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
      SistrixVisibilityIndex.column_names.include?(params[:sort]) ? params[:sort] : "sistrix_index"
  end
    
  def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end


