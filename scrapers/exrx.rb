#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"
require 'open-uri'

agent = "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36"
url = "http://2.hidemyass.com/ip-1/encoded/Oi8vZXhyeC5uZXQvTGlzdHMvRGlyZWN0b3J5Lmh0bWw%3D"
doc = Nokogiri::HTML(open(url, "User-Agent" => agent))

anatomy_td = doc.css("td[valign='TOP'][width='50%']")[0]
anatomy_links = anatomy_td.css("a")
anatomy_links.each do |l|
  puts l
end