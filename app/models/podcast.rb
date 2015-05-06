class Podcast < ActiveRecord::Base
	has_many :content
	belongs_to :user

	def after_intialize
		root = parse_rss(self.url)

		self.title = root.elements["channel"].elements["title"].text
		self.last_check = last_update_date(root)

		self.contents = Array.new
		root.each_element("//item") { |item| self.contents << make_content_from_rss(item) }
	end

	def update
		root = parse_rss(self.url)
		if self.last_check < last_update_date(root)
			root.each_element("//item") { |item| self.contents << make_content_from_rss(item) if get_pub_date(item) > self.last_check }
		end
		self.last_check = DateTime.current
	end

	private

	def get_pub_date(item)
		DateTime.parse(item.elements["pubDate"].text)
	end

	def make_content_from_rss(item)
		Content.new(title: item.elements["title"].text, description: item.elements["description"].text, url: item.elements["enclosure"].attributes["url"], release_date: get_pub_date(item))
	end

	def parse_rss(url)
		file = open(url)
		doc = Document.new(file)
		doc.root
	end

	def last_udpate_date(root)
		DateTime.parse(root.elements["channel"].elements["lastBuildDate"].text)
	end
end
