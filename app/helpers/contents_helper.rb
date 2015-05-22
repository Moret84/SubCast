module ContentsHelper
	def content_src_url(content)
		if content.url.start_with?('http')
			content.url.to_s
		else
			content.url.to_s.sub(Rails.root.to_s + '/public', "")
		end
	end
end
