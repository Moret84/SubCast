module UserHelper

	def content_element type, value
		result = (type == :title) ? "Titre: " : "Description: "
		result += value.blank? ? "Non précisé" : value
		content_tag :p, result
	end

	def progress_bar level
		bar = content_tag(:div, level + '%', class: "progress-bar", role: "progressbar", :aria => {valuemin: "0", valuemax: "100", valuenow: level}, style: "width: " + level + "%; min-width: 2em;" )
		content_tag(:div, bar, class: "progress")
	end
end
