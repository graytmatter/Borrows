class ApplicationController < ActionController::Base
  protect_from_forgery

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
      "Camping"     => "Borrow to unplug",
      "BBQ"         => "Borrow for a sunny day",
      "DIY"         => "Borrow to do-it-yourself",
      "Backpacking" => "Borrow for the backcountry",
      "Cooking"     => "Borrow for the dream meal",
      "Skiing"      => "Borrow to catch some air"
    }

    # Camping http://hdwallpapersci.com/wp-content/uploads/2013/11/dsfsdf1.jpg
    # Skiing http://www.wallpapersdesign.net/wallpapers/2013/12/Ski-Jump-1080x1920.jpg
    # BBQ http://acorporateeventplanning.com/wp-content/uploads/2012/06/iStock_000002242776Large.jpg
    # Backpacking http://lndblog.files.wordpress.com/2012/06/backpacking1.jpg
    # Cooking http://www.experiensense.com/wp-content/uploads/2012/12/sonos_kitchen_cooking.jpg
    # DIY http://1.bp.blogspot.com/-IBUpITB2EiU/T6g15WrgDtI/AAAAAAAAAJA/LRqI5UJ2KBQ/s1600/workshop2.jpg

    # Baby http://www.hdwallpapersin.com/files/submissions/Child_Girl_Bear_Toy_Autumn_Leaves_Nature_Photo_HD_Wallpaper_1395004946.jpg
    # Interior http://img.wallpaperstock.net:81/beautiful-furniture-wallpapers_17618_1920x1080.jpg
    # Volleyball http://www.wallsave.com/wallpapers/1920x1080/beachvolleyball/414822/beachvolleyball-beach-volleyball-serving-jump-hd-and-414822.jpg
    # Stroller http://ak1.picdn.net/shutterstock/videos/5905997/preview/stock-footage-happy-parents-tending-to-baby-girl-in-pram-in-the-park-on-a-sunny-day.jpg
    

  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN_ID"] && password == ENV["ADMIN_PASSWORD"]
    end
  end
  
end
