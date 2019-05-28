require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").each do |student|
      student_hash = {:name => student.css(".student-name").text,
      :location => student.css(".student-location").text,
      :profile_url => student.css("a").attribute("href").value}
      students << student_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    profile_links = {}
    profile_link = doc.css(".social-icon-container a").map {|a| a.attribute("href").value }
    profile_link.each do |link|
      if link.split("/").include?("twitter.com")
        profile_links[:twitter] = link
      elsif link.split("/").include?("www.linkedin.com")
        profile_links[:linkedin] = link
      elsif link.split("/").include?("github.com")
        profile_links[:github] = link
      else
        profile_links[:blog] = link
      end
    end
    profile_hash = {:profile_quote => doc.css(".profile-quote").text,
    :bio => doc.css(".bio-content .description-holder p").text.split(" ").join(" ")}
    profile_links.merge(profile_hash)
  end


end
