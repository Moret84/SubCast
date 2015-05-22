class Theme < ActiveRecord::Base
	has_and_belongs_to_many :users

	def new_content
		search = Content.search do
			fulltext self.name
		end
		news = []
		search.results.each do |content|
			if content.created_at > self.last_check
				news.push(content)
			end
		end
		if news.any?
			self.users.each do |user|
				TcMailer::new_content_released(user,self, news).deliver_now
			end
		end
		self.last_check = DateTime.current
		self.save
	end

	def self.check_all
		self.all.each do |theme|
			theme.new_content
		end
	end
end
