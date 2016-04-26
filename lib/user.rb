require "watir"
require 'watir-webdriver'
require 'nokogiri'
require 'open-uri'
class User
	def initialize(login_url = 'https://www.lynda.com/login/login.aspx')
		@login_url = login_url
	end
	def username=(username)
		@username = username
	end
	def password=(password)
		@password = password
	end	

	def login_to_lynda_with_company_account browser
		browser.text_field(:name, "usernameInput").set(@username)
		browser.text_field(:name, "passwordInput").set(@password)
		browser.button(:id,'lnk_login').click	
		return browser	
	end

	def login_to_lynda browser
		browser.text_field(:name, "usernameInput").set(@username)
		browser.text_field(:name, "passwordInput").set(@password)
		browser.button(:id,'lnk_login').click
		return browser
	end	

	def login		
		login_success = true
		browser = Watir::Browser.new(:phantomjs)
		browser.goto @login_url		
		browser = self.login_to_lynda(browser)
		html_source = browser.html
		doc = Nokogiri::HTML(html_source)
		if doc.css('div#login-error>h3')
			if doc.css('div#login-error>h3').text.length > 0
				login_success = false
				browser.close
			else
				login_success = browser
			end
		else
			login_success = browser
		end		
		return login_success		
	end	
end