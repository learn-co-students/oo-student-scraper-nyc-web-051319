require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    profiles = []
    doc = Nokogiri::HTML(File.read(index_url))
    doc.css("div.roster-cards-container div.student-card").each do |profile|
      #id = profile.attribute("id").value
      curr_profile = {
        name: profile.css("div.card-text-container h4.student-name").text,
        location: profile.css('div.card-text-container p.student-location').text,
        profile_url: profile.css("a").attribute("href").value
      }
      profiles << curr_profile
    end
    profiles
  end

  def self.scrape_profile_page(profile_url)
    curr_profile = {}
    doc = Nokogiri::HTML(File.read(profile_url))
    doc.css("div.social-icon-container a").each do |social|
      attr_value = social.attribute("href").value
      icon_value = social.css("img").attribute("src").value
      if icon_value.include?("twitter")
        curr_profile[:twitter] = attr_value
      elsif icon_value.include?("linkedin")
        curr_profile[:linkedin] = attr_value
      elsif icon_value.include?("github")
        curr_profile[:github] = attr_value
      elsif icon_value.include?("rss")
        curr_profile[:blog] = attr_value
      end
    end
    
    curr_profile[:profile_quote] = doc.css("div.profile-quote").text
    curr_profile[:bio] = doc.css("div.bio-block.details-block div.description-holder p").text

    curr_profile
  end

end

Scraper.scrape_index_page('fixtures/student-site/index.html')
