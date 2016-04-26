require "watir"
require 'watir-webdriver'
require 'nokogiri'
require 'open-uri'
class Course

	def initialize(logged_in_browser)
		@browser = logged_in_browser
	end

	@@course_parsed = false

	attr_accessor :course_url

	def save
		return false unless self.download_from_lynda		
		return true
	end

	def download_from_lynda
		@browser.goto @login_url
		self.parse_the_page
		@browser.close
	end

	def parse_the_page
		@browser.goto @course_url
		html_source = @browser.html
		doc = Nokogiri::HTML(html_source)
		toc = doc.css('ul.course-toc li')
		video_chapters = []
		chapter_count = 0
		toc.each do |chapter|
			chapter_title = chapter.css('h4.ga').text		
			if chapter_title.length > 2
				p "this is #{chapter_title}"
				video_chapter = Hash.new
				chapter_title = chapter_title.gsub(/\s+|\?|\(|\)|\/|\:|\,/, " ")
				chapter_title.strip!
				video_chapter["chapter_title"] = chapter_title
				video_chapter["items"] = []
				video_chapters << video_chapter
				chapter_count = chapter_count + 1
			end
			item_number = 1
			items = chapter.css('ul.toc-items li')
			items.each do |item|
				title = item.css('a.item-name').text
				title = title.gsub(/\s+|\?|\(|\)|\/|\:|\,/, " ")
				title.strip!
				item_title = title.tr(" ", "_")
				item_url = item.css('a.item-name')[0]['href']
				final_item_title = "#{item_number}.#{item_title}"
				video_item = Hash.new
				video_item["item_title"] = final_item_title
				video_item["url"] = item_url
				video_chapters[(chapter_count-1)]["items"].push(video_item)
				item_number = item_number+ 1
			end
		end
		video_chapters.each do |chapter|
			chapter["items"].each do |item|
				video_title = item["item_title"]
				p video_title
				@browser.goto item["url"]
				doc = Nokogiri::HTML(@browser.html)
				video = doc.css('#courseplayer .player')
				if video
					video.each do |v|
						video_url = v['data-src']
						if video_url
							item["video_url"] = video_url
							sleep(30)
						end
					end
				end
			end
		end	
		return video_chapters	
	end
end