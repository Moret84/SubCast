require 'date'
require 'nokogiri'
require 'webvtt'
require 'rexml/document'
require 'net/http'
require 'uri'
require 'open-uri'
require 'json'
require 'fileutils'
require 'yaml'
include REXML

class Content < ActiveRecord::Base
	enum status: [ :nothing, :uploading, :uploaded, :transcribing, :transcribed, :finished ]
	has_and_belongs_to_many :users
	belongs_to :podcast
	attr_accessor :file_upload, :context_file

	REST_API = YAML::load_file(Rails.root/config/rest_api.yml)["url"]

	def webVTT_from_TRS
		dir = Rails.root.to_s + '/public/transcriptions/' + self.id.to_s
		source = dir + '/transcription.trs'
		target = dir + '/transcription.vtt'
		f = File.new(target, 'w')
		f.puts 'WEBVTT'
		file = open(source)
		i = 1
		document = Document.new(file)
		root = document.root
		root.each_element("//Turn") do |turn|
			text = ""
			f.puts
			f.puts i
			i += 1
			f.puts Time.at(turn.attributes["startTime"].to_f).utc.strftime("%H:%M:%S.%L") + ' --> ' + Time.at(turn.attributes["endTime"].to_f).utc.strftime("%H:%M:%S.%L")
			alts = turn.get_elements("Alt")
			if alts.length == 0
				f.puts turn.texts[1].to_s.strip
			else
				max = 0
				alts.each do |alt|
					votes = alt.attributes["votes"].to_s
					votes = votes.to_i
					if votes > max
						text = alt.text
						max = votes
					end
				end
				f.puts text
			end
		end
		f.close
	end

	def correct(cue_id, correction)
		file = open(Rails.root.to_s + '/public/transcriptions/' + self.id.to_s + '/transcription.trs')
		document = Document.new(file)
		root = document.root
		turn = root.get_elements("//Turn")[cue_id.to_i-1]
		alts = turn.get_elements("Alt")
		if alts.length == 0
			element = turn.add_element "Alt", {"votes" => "1"}
			element.text=correction
		else
			exists = false
			alts.each do |alt|
				if alt.text.to_s == correction
					votes = alt.attributes["votes"].to_i
					votes += 1
					alt.add_attribute("votes", votes.to_s)
					exists = true
				end
			end
			if exists == false
				element = turn.add_element "Alt", {"votes" => "1"}
				element.text=correction
			end
		end
		File.open(Rails.root.to_s + '/public/transcriptions/' + self.id.to_s + '/transcription.trs',"w") do |data|
			data << document
		end
		self.webVTT_from_TRS
		Sunspot.delay.index(self)
		Sunspot.delay.commit
	end

	def self.isContent?(str)
		open(str).content_type.starts_with? 'audio'
	end

	def self.check_all
		self.all.each do |content|
			case content.status
			when "nothing"
				content.delay.upload
			when "uploaded"
				content.delay.transcribe
			when "transcribing"
				content.delay.check_progress
			when "transcribed"
				content.delay.fetch_result
				content.delay.webVTT_from_TRS
				Sunspot.delay.index(content)
				Sunspot.delay.commit
				content.status = :finished
				content.save
			end
		end
	end

	def upload
		uri = URI('#{REST_API}/file')
		file = open(self.url)
		type = File.extname(self.url).delete "."
		request = Net::HTTP::Post.new(uri)
		request.basic_auth 'ceri', 'projet'
		request.set_form_data('type' => type, 'content' => file.read())
		result = JSON.parse(Net::HTTP.start(uri.host, uri.port).request(request).body)
		if result['status'] == "OK"
			self.status = :uploaded

			#ID of the file on the server
			self.on_server_id = result['id']
			self.save
		end
	end

	def transcribe
		if self.uploaded?
			uri = URI('#{REST_API}/analyse')
			request = Net::HTTP::Post.new(uri)
			request.basic_auth 'ceri', 'projet'
			self.status = :transcribing
			request_params = { 'file_id' => self.on_server_id, 'type' => 'full' }
			if File.exist?(self.get_dir + 'context')
				file = open(self.get_dir + 'context')
				request_params['description'] = file.read
			end
			request.set_form_data(request_params)
			result = JSON.parse(Net::HTTP.start(uri.host, uri.port).request(request).body)

			#ID of the transcription
			self.on_server_id = result['id']
			self.save
		end
	end

	def check_progress
		if self.transcribing?
			uri = URI('#{REST_API}/analyse/' + self.on_server_id)
			request = Net::HTTP::Get.new(uri)
			request.basic_auth 'ceri', 'projet'
			result = JSON.parse(Net::HTTP.start(uri.host, uri.port).request(request).body)
			if result['status'] == "finished"
				self.status = :transcribed
				self.save
				self.users.each { |user| TcMailer::transcribed_content(user, self).deliver_now }
				self.podcast.users.each { |user| TcMailer::transcribed_content_in_podcast(user, self).deliver_now } if !self.podcast.nil?
			end
			result['completion']
		elsif self.transcribed? || self.finished?
			100
		else
			0
		end
	end

	def fetch_result
		for type in [ 'ctm', 'xml', 'trs' ]
			targetFullDir = Rails.root.to_s + '/public/transcriptions/' + self.id.to_s
			targetFullPath = targetFullDir + '/transcription.' + type

			if !File.exist?(targetFullDir)
				FileUtils.mkpath(targetFullDir)
			end

			if !File.exist?(targetFullPath)
				uri = URI('#{REST_API}/analyse/' + self.on_server_id + '/result.' + type)
				request = Net::HTTP::Get.new(uri)
				request.basic_auth 'ceri', 'projet'
				result = JSON.parse(Net::HTTP.start(uri.host, uri.port).request(request).body)

				file = File.new(targetFullPath, 'w')
				file.puts(result['val'])
				file.close
			end
		end
	end

	def get_dir
		Rails.root.to_s + '/public/transcriptions/' + self.id.to_s + '/'
	end

	private

	searchable :auto_index => false do
		text :title
		text :file_text
	end

	def file_text
		vtt = Webvtt::File.new(self.get_dir + 'transcription.vtt')
		vtt_text_lines = vtt.cues.map{|cue| cue.text}
		full_text = vtt_text_lines.join(' ')
		clean_full_text = Nokogiri::HTML(full_text).text
		return clean_full_text
	end
end
