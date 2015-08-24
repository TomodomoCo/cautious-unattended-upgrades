require "headless"
require "selenium-webdriver"

Headless.ly do
	browser = Selenium::WebDriver.for :firefox

	browser.get "https://www.vanpattenmedia.com"

	browser.find_element(link_text: "About Van Patten Media").click

	browser.find_element(link_text: "Blog").click

	browser.find_element(id: "input_2_1")

	browser.get "https://www.vanpattenmedia.com/blog/page/2"

	browser.find_element(link_text: "Portfolio").click

	browser.get "https://www.vanpattenmedia.com/wp/wp-admin"

	browser.find_element(id: "wp-submit")
end
