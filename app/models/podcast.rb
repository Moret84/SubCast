require 'feed_validator'
require 'open-uri'
require 'rexml/document'
include REXML

class Podcast < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_many :contents

	private def last_update_date(root)
		DateTime.parse(root.elements["channel"].elements["lastBuildDate"].text)
	end

	def parse
		root = parse_rss(self.rss_link)

		self.title = root.elements["channel"].elements["title"].text
		self.last_check = last_update_date(root)

		self.update(root)

		self.save
	end

	def update(root)
		root.each_element("//item") { |item| self.contents << make_content_from_rss(item) if get_pub_date(item) > self.last_check }
		self.last_check = DateTime.current
	end

	def self.isPodcast?(str)
		W3C::FeedValidator.new.validate_url(str)
	end

	def self.check_all
		self.all.each do |podcast|
		root = parse_rss(podcast.rss_link)
		update(root)
		end
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

end
