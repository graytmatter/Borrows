class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN_ID"] && password == ENV["ADMIN_PASSWORD"]
    end
  end

  def call_rake(task, options = {})
      options[:rails_env] ||= Rails.env
      args = options.map { |n, v| "#{n.to_s}=#{v}" }
      rake_path = "/Users/jamesdong/.rvm/gems/ruby-2.1.2@global/bin/rake"
      puts "INSPECT"
      puts args.inspect 
      puts "#{rake_path} #{task} #{args.join(' ')}".inspect
      puts "END"
      system "#{rake_path} #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
      # need to add path to rake /usr/bin/rake, etc.
  end
  
  def itemlist
      @itemlist = {
      #13 items each
      "Camping" => [
      	"2-Person Tent", 
      	"3-Person Tent", 
      	"4-Person Tent",
      	"Sleeping bag", 
      	"Sleeping pad",
      	"<40L Daypack", 
      	"<40L Pack rain cover",
      	"Portable stove", 

      	"1-Person Tent",  
      	"6-Person Tent", 
      	"8-Person Tent", 
      	"10-Person Tent",   
      	"Bear canister" 
      	],
      "Backpacking" => [ 
      	"80L+ Frame pack", 
      	"80L+ Pack rain cover",
      	"60-80L Frame pack",
      	"Water purifier", 
      	"Pocket stove",  
      	"Dry bag", 
      	"Headlamp",
      	"Backpacking hammock",

      	"Trekking pole set",
      	"60-80L Pack rain cover",
      	"40-60L Frame pack",  
      	"40-60L Pack rain cover", 
      	"Camp cookware set" 
      	],
      "Kitchenwares" =>[
      	"Blender", 
      	"Electric grill", 
      	"Food processor", 
      	"Baking dish", 
      	"Knife sharpener", 
      	"Immersion blender", 
      	"Juicer", 
      	"Rice cooker",
      	
      	"Springform cake pan", 
      	"Sandwich/panini press", 
      	"Hand/stand mixer", 
      	"Ice cream maker", 
      	"Pressure canner"
      	],
      
      #9 items each
      "Housewares" => [
      	"Vacuum", 
      	"Air mattress", 
      	"Iron & board set", 
      	"Carry-on Luggage", 
      	"Check-in Luggage", 
      	"Extension cords", 
      	"Jumper cables",
      	"Sewing machine", 

      	"Steam cleaner"
      	], 
      "Tools" => [
      	"Electric drill", 
      	"Hammer", 
            "Sliding wrench", 
            "Utility knife", 
            "Level",
            "Screwdriver set", 
      	"Yardstick", 
      	"Measuring tape",

      	"Handsaw"
      	],
      "Park & picnic" => [
            "Shade structure",  
            "Portable grill", 
            "Portable table", 
            "Portable chair",
            "Portable lantern",
            "Portable hammock",
      	"Large cooler", 
      	"Small/personal cooler",

      	"Portable speaker set" 
      	],

      #8 items each
      "Sports gear" => [
      	"Tennis set", 
      	#"Volleyball set", 
      	"City bike", 
      	"Mountain bike", 
      	"Bike helmet", 
      	"Bike pump", 
      	"Football", 
      	"Soccerball", 
      	"Basketball" 
      	],
      "Snow sports gear" => [
      	"Top Outerwear", 
      	"Bottom Outerwear", 
      	"Top Thermalwear", 
      	"Bottom Thermalwear", 
      	"Glove pair" , 
      	"Helmet", 
      	"Goggles", 
      	"Crampon pair"
      	],
      "Baby gear" => [
      	"Umbrella stroller", 
      	"Booster seat", 
      	"Carrier", 
      	"Pack n' Play", 
      	"Jumper", 
      	"Bassinet", 
      	"Backpacking carrier", 
      	"Car seat"
      ]
    }
  end
end
