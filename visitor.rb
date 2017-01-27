require 'nokogiri'
require 'open-uri'
require 'uri'
require 'base64'
require 'yaml'

queue   = YAML::load_file('./queue.yml')
visited = YAML::load_file('./visited.yml')
queue   = queue
visited = visited

while true
  url = queue[0]
  queue.shift
  puts "Visiting: #{url}"
  visited << url
  begin 
	  doc = open(url)
	  page = doc.read
	  html_doc = Nokogiri::HTML(page)
	  links = html_doc.css("a")
	  links.each do |link|
	    new_url = link.attr("href")
	    unless new_url.empty?
	      if new_url =~ URI::regexp
	        unless visited.include? new_url
	          queue << new_url
	        end
	      end
	    end
	  end 
	rescue => e 
		puts "Faulty: #{url}"
	end
  
	File.open('./queue.yml', 'w') {|f| f.write queue.to_yaml } #Store
	File.open('./visited.yml', 'w') {|f| f.write visited.to_yaml } #Store

end

