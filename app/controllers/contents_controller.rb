class ContentsController < ApplicationController
	def show
		@content = Content.find(params[:id])
		@transcription = Rails.root.to_s + "/transcriptions/" + params[:id] + "/transcription.vtt"
	end
end
