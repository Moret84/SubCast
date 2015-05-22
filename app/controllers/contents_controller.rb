class ContentsController < ApplicationController
	def show
		@content = Content.find(params[:id])
		@transcription = "/transcriptions/" + params[:id] + "/transcription.vtt"
	end

	def correct
		@content = Content.find(params[:id])
		if params.has_key?(:cue_id) and params.has_key?(:correction)
			@content.correct(params[:cue_id],params[:correction])
		end
		render nothing: true
	end

	def search
		@title = "Recherche"
		if params.has_key?(:search)
			@search = Content.search do
				fulltext params[:search]
			end
			@contents = @search.results
		end
	end

	def create
		@content = Content.new(content_params)
		if !@content.file_upload.blank? || !@content.url.blank? && Content.isContent?(@content.url)
			@content.status = "nothing"
			content = Content.find_by(url: @content.url)
			if content.nil?
				@content.save
				if !@content.file_upload.blank?
					@content.url = @content.get_dir + "file.mp3"
					save_file(@content.file_upload, @content.url)
				end

				if !@content.context_file.blank?
					save_file(@content.context_file, @content.get_dir + 'context')
				end
			else
				@content = content
			end
			current_user.contents << @content

			flash.now[:success] = "Votre contenu a bien été ajouté ! Vous serez prévenu quand il sera transcrit."
		else
			flash.now[:danger] = "Vous n'avez rien donné à transcrire !"
		end
	end

	private

	#Need to say which arguments have to be specified
	def content_params
		params.require(:content).permit(:title, :description, :url, :file_upload, :context_file)
	end

	def save_file(file, path)
		dir = File.dirname(path)
		if !File.exist?(dir)
			FileUtils.mkpath(dir)
		end
		File.open(path, "wb") { |f| f.write(file.read) }
		path
	end
end
