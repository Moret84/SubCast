require 'feed_validator'
require 'open-uri'
require 'rexml/document'
include REXML

class Podcast < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_many :contents

	def check_news
		feed = Feedjira::Feed.fetch_and_parse(self.rss_link)
		feed.entries.each { |item| self.contents << make_content_from_rss(item) if item.published > self.last_check }
		self.last_check = DateTime.current

		self.save
	end

	#First parsing
	def parse
		feed = Feedjira::Feed.fetch_and_parse self.rss_link

		self.title = feed.title
		self.description = feed.description
		self.last_check = DateTime.current

		self.check_news

		self.save
	end


	def self.isPodcast?(str)
		feed = W3C::FeedValidator.new
		feed.validate_url(str)
		feed.valid?
	end


	def self.check_all
		self.all.each do |podcast|
			podcast.check_news
		end
	end

	private


	def make_content_from_rss(item)
		content = Content.create(title: item.title, description: self.description, url: item.enclosure_url, release_date: item.published, status: "nothing")
	end

end
