module CheckHelper

	def sortable_theme(column, title = nil)
	  title ||= column.titleize
	  css_class = column == sort_column_theme ? "current #{sort_direction}" : nil
	  direction = column == sort_column_theme && sort_direction == "asc" ? "desc" : "asc"
	  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
	end

	def sortable_article(column, title = nil)
	  title ||= column.titleize
	  css_class = column == sort_column_article ? "current #{sort_direction}" : nil
	  direction = column == sort_column_article && sort_direction == "asc" ? "desc" : "asc"
	  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
	end

	
end
