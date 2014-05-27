class ApplicationController < ActionController::Base

before_action :redirect_to_www if Rails.env == "production"

  def redirect_to_www
    unless /www\.projectborrow\.com/ =~ request.url
      uri = URI.parse(request.url)
      uri.host = "www.projectborrow.com"
      redirect_to uri.to_s
    end
  end

  def howto 
    @howtoimages = {
      "One" => "Tell us what you need",
      "Two" => "We email item location",
      "Three" => "You pick up or we deliver"
    }

    # One (Form) http://img.allvoices.com/thumbs/event/609/480/59012320-pen-paper.jpg
    # Two (Mail) http://img.allw.mn/www/thumbs/104/930.jpgs
    # Three (Gift) http://cdn.smugmug.com/img/help/personal-delivery/personal-delivery-box-1.jpg
  end

  def images
    @images = {
      "Camping" => "Borrow to unplug for the weekend",
      "BBQ" => "Borrow to enjoy a sunny afternoon",
      "Interior" => "Borrow to do-it-yourself",
      "Stroller" => "Borrow to take them along",
      "Skiing" => "Borrow to catch some air"
    }

    # Stroller http://ak1.picdn.net/shutterstock/videos/5905997/preview/stock-footage-happy-parents-tending-to-baby-girl-in-pram-in-the-park-on-a-sunny-day.jpg
    # Camping http://hdwallpapersci.com/wp-content/uploads/2013/11/dsfsdf1.jpg
    # Interior http://img.wallpaperstock.net:81/beautiful-furniture-wallpapers_17618_1920x1080.jpg
    # Volleyball http://www.wallsave.com/wallpapers/1920x1080/beachvolleyball/414822/beachvolleyball-beach-volleyball-serving-jump-hd-and-414822.jpg
    # Skiing http://www.wallpapersdesign.net/wallpapers/2013/12/Ski-Jump-1080x1920.jpg
    # Baby http://www.hdwallpapersin.com/files/submissions/Child_Girl_Bear_Toy_Autumn_Leaves_Nature_Photo_HD_Wallpaper_1395004946.jpg
    # BBQ http://acorporateeventplanning.com/wp-content/uploads/2012/06/iStock_000002242776Large.jpg
  end
  
end
