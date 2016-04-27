require 'fileutils'
class Lyndafile
	attr_accessor :args, :file_name

	def save
		filepath = File.join(File.dirname(__FILE__), '..','..',"#{file_name}.sh")
		#filepath = "/Users/joshchen1985/Desktop/#{file_name}.sh"
		File.open(filepath, 'a') do |file|
			@args.each do |chapter|
				chapter_title = chapter["chapter_title"]				
				p chapter_title
				file.puts "mkdir -p \"#{file_name}/#{chapter_title}\"\n"
				chapter["items"].each do |item|
					video_title = item["item_title"]
					video_url = item["video_url"]
					video_name = "#{video_title}.mp4"
					p video_title
					file.puts "curl -o \"#{file_name}/#{chapter_title}/#{video_name}\" \"#{video_url}\"\n"
					#file.puts "#{[chapter_title, video_title, video_url, video_name].join("\t")}\n"
				end
			end				
		end		
	end
end
