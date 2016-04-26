require "watir"
require 'watir-webdriver'
require 'nokogiri'
require 'open-uri'

class User
	attr_accessor :organization
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
		browser.text_field(:id, "usernameInput_org").set(@username)
		browser.text_field(:id, "passwordInput_org").set(@password)
		browser.button(:id,'lnk_login_org').click	
		return browser
	end

	def login_to_lynda browser
		browser.text_field(:id, "usernameInput").set(@username)
		browser.text_field(:id, "passwordInput").set(@password)
		browser.button(:id,'lnk_login').click
		return browser
	end	

	def login
		login_success = true
		browser = Watir::Browser.new(:phantomjs)
		browser.goto @login_url
		if @organization == 'y'
			browser = self.login_to_lynda_with_company_account(browser)
		else
			browser = self.login_to_lynda(browser)
		end
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