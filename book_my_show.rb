require 'rubygems'
require 'nokogiri'
require 'httparty'
require 'pry'
require 'pony'

class BookMyShow
  def self.send_me_notification
    Pony.mail({
      :to => 'username@email_provider.com',
      :subject => "Scrapper Notification",
      :body => "Keyword is found in BookMyShow Scrapper. Hurry Up!",
      :via => :smtp,
      :via_options => {
        :address              => 'smtp.gmail.com',
        :port                 => '587',
        :enable_starttls_auto => true,
        :user_name            => 'username@email_provider.com',
        :password             => 'password',
        :authentication       => :plain,
        :domain               => "localhost.localdomain"
      }
    })  
  end
end

# main
url = "https://in.bookmyshow.com/buytickets/sarrainodu-hyderabad/movie-hyd-ET00038117-MT/20160422"
loop do
  page = HTTParty.get(url)
  scrapped_page = Nokogiri::HTML(page)
  theatre_names = scrapped_page.css(".__venue-name strong").map(&:text)
  theatre_names.each do |name|
    if name =~ /.?Miyapur$/i
      # Miyapur Theatre Found
      puts "Miyapur Found: #{Time.now}"
      BookMyShow.send_me_notification
    else
      puts "Not Found"
    end
  end if !theatre_names.empty?
  sleep(900)
end
