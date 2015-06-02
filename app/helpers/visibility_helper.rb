module VisibilityHelper

	def sortable_visibility(column, title = nil)
		  title ||= column.titleize
		  css_class = column == sort_column_visibility ? "current #{sort_direction}" : nil
		  direction = column == sort_column_visibility && sort_direction == "asc" ? "desc" : "asc"
		  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
	end

end

