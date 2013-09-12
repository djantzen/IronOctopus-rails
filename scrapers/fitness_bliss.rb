#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"
Capybara.run_server = false
Capybara.current_driver = :webkit
Capybara.app_host = "http://my.fitnessbliss.com"
Capybara.javascript_driver= :webkit

class FitnessBliss
  include Capybara::DSL

  def login
    visit("/fbo/login.seam")
    fill_in("loginFormId:username", :with => "quackquack")
    fill_in("loginFormId:password", :with => "QuackQuack")
    click_button("loginFormId:loginButtonId")
  end

  def get_results
    visit("/fbo/exercise_browser.seam")
    save_page
    select("(All)", :from => "j_id30:SlctMuscle")
    sleep(10)
    save_page
    #save_and_open_page
    trs = all(".iceDatTblRow1")
    puts trs.size
    trs.each do |tr|
      puts tr.text()
    end

    #all(:xpath, "//li[@class='g']/h3/a").each { |a| puts a[:href] }

  end
end

spider = FitnessBliss.new
spider.login
spider.get_results
