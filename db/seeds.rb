# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

status_codes = [
	"Searching",
	"In progress",
	"Cancelled - No response from borrower",
	"Cancelled - No response from lender",
	"Cancelled - Time period too long",
	"Cancelled - Inventory not available",
	"Cancelled - Out of area",
	"Cancelled - Request too last minute",
	"Cancelled - Occasion for use cancelled",
	"Cancelled - Didn't actually need item",
	"Cancelled - Inventory not suitable",
	"Cancelled - Borrowed elsewhere",
	"Cancelled - Rented elsewhere",
	"Cancelled - Bought elsewhere",
	"Complete",
	"Dispute",
	"Complete - Damages settled",
	"Complete - Replacement settled"
]

status_codes.each do |s|
	Status.create(status_meaning: s)
end

  itemlist = {
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

itemlist.each do |c, i|
	Categorylist.create(name: c)
	i.first(8).each do |i|
		Categorylist.find_by_name(c).itemlists.create(name: i, request_list: true, inventory_list: true)
	end
	temp = i - i.first(8)
	temp.each do |i|
		Categorylist.find_by_name(c).itemlists.create(name: i, request_list: false, inventory_list: true)
	end
end
