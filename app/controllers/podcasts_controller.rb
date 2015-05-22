class PodcastsController < ApplicationController

	def create
		@podcast = Podcast.new(podcast_params)
		if !@podcast.rss_link.blank? && Podcast.isPodcast?(@podcast.rss_link)
			podcast = Podcast.find_by(rss_link: @podcast.rss_link)
			if podcast.nil?
				@podcast.save
			else
				@podcast = podcast
			end
			current_user.podcasts << @podcast
			@podcast.delay.parse
			flash.now[:success] = "Vous vous êtes bien abonné à ce podcast. Vous serez prévenu de la transcription des nouvelles émissions."
		else
			flash.now[:danger] = "URL invalide"
		end
	end

	private

	def podcast_params
		params.require(:podcast).permit(:rss_link)
	end
end
