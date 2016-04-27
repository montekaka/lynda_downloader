require 'course'
require 'user'
require 'Lyndafile'
class Guide

	def launch!
		introduction
		result = nil
		until result == :quit
			action = gets.chomp
			result = do_action(action)
		end
		conclusion
	end

	def get_action
		#action = nil
		action = gets.chomp
	end
	def do_action(action)
		case action
		when 'login'
			puts "To start, please enter your Username and Password"
			print "Username: "
			@username = gets.chomp.strip
			print "Password: "
			@password = gets.chomp.strip
			print "Are you Organization Login (y/N)?: "
			@organization = gets.chomp.strip
			logged_in_browser = login
			if logged_in_browser
				puts "Successful logged in \n\n"
				puts "Please enter the Course URL you wish to download"
				print "Course URL: "
				course_url = gets.chomp.strip				
				course = download(course_url,logged_in_browser)

				if course == false
					puts 'Fails to download the course'
				else
					p course.count
					output_file(course)		
					p "Output finish"			
				end
			else
				puts "not successful"
			end
		when 'quit'
			return :quit
		else
			puts "I don't understan that command \n"
		end
	end
	def introduction
		puts "\n\n<<< Welcome to the Lynda Downloader >>>\n\n"
		puts "This is an interactive guide to help you to download from lynda.\n\n"		
	end	

	def login
		user = User.new
		user.username = @username
		user.password = @password
		user.organization = @organization
		user.login
		#user.save
	end

	def download(course_url,logged_in_browser)
		course = Course.new(logged_in_browser)
		course.course_url = course_url
		course_download = course.download
		if course_download
			puts "\nCourse saved\n\n"
			return course_download
		else
			puts "\nSave Error: Course not added"
		end
	end

	def output_file args
		prints "Save file as: "
		file_name = gets.chomp.strip
		file = Lyndafile.new
		file.args = args
		file.file_name = file_name
		#file.file_name = "Andriod"
		file.save
	end
	def conclusion
		puts "\n<<< Goodbye! >>>\n\n\n"
	end	
end