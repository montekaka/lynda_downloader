require 'course'
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
			download
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

	def download
		puts "Enter the course URL to start"
		course_url = gets.chomp.strip
		course = Course.new
		course.username = @username
		course.password = @password
		course.course_url = course_url
		if course.save
			puts "\nCourse saved\n\n"
		else
			puts "\nSave Error: Course not added"
		end
	end

	def conclusion
		puts "\n<<< Goodbye! >>>\n\n\n"
	end	
end