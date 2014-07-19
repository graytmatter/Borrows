# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

status_codes = {

#First column: Did borrower use or not use Project Borrow?

  "1 Did use PB" => [
    "Searching", #Default status, assumes that PB will help
    "Connected", #Automatically set if a connection is made between borrower and lender
    "In progress", #Follows In Progress, automatically set on the Pick Up Date of Connected borrows, I have to manually adjust if one party informs me otherwise  
    "Complete - OK", #Follows In Progress, automatically set on the Return Date, I have to manually adjust if one party tells me otherwise
    "Complete - Disputing", #Follow In Progress, something went wrong
    "Complete - Settled Informally", #Follows Complete - Disputing, indicates that some settlement was reached mediated by PB at most
    "Complete - Settled Formally" #Follows Complete - Disputing, indicates that some settlement was reached that required legal action
  ],

  #What was the primary reason where, had it not been the case, the borrow would have happened and the borrower would have used PB?

  #FC = False Cancel, with slight changes in circumstance, the borrow could have happend
  #TC = True Cancel, very likely that the borrower would have cancelled no matter what changes in circumstance

  "1 Did not use PB" => [
    "FC - No response from borrower", #I have to manually set, e.g., if lender tells me
    "FC - No response from lender", #Manual set or Auto set if the end of the pick up date comes up 
    "FC - Borrower forgot last minute", #Manual set if one party informs me, E.g., borrower did not pick up at scheduled time, and didn't change the time
    "FC - Lender forgot last minute", #Manual set if one party informs me, E.g., lender forgot to make item available at scheduled time, and didn't change the time
    "FC - Scheduling conflict", #Manual set if one party informs me, 
    "FC - Out of area", #Will build an auto check for this, but still manual set if someone tries to sneak it 
    "FC - Inventory not suitable", #Manual set if one party informs me, E.g., specifications not met
    "FC - Too inconvenient (time/money cost)", #Manual set if one party informs me, 
    "FC - Found sale",

    # Eventually this section should be all auto-set
    "TC - Occasion for use cancelled",
    "TC - Item not actually needed", #E.g., consumer education, water filters not needed for car camping
    "TC - Mistaken or trial request", #E.g., didn't even mean to submit
    "TC - Borrower already got it", #Auto-set E.g., borrow already connected with lender
    "TC - Lender declined", #Auto-set E.g., lender cancels
    "TC - Lender already gave it", #Auto-set E.g., lender already accepted someone else's request for a conflicitng time
    "TC - Actually needs item frequently" #E.g., buying makes more sense
  ],

#Second column, more info for Complete - Settled what settlement was reached or if PB was not used what borrower did instead

  "2 Did use PB" => [ #these are all manually set because they are about disputes
    "Borrower paid to replace lost item",
    "Project Borrow paid to replace lost item",
    
    "Borrower paid to repair damaged item",
    "Project Borrow paid to repair damaged item",
    
    "Project Borrow paid to replace stolen item",
    
    "Lender said no big deal to loss/theft",
    "Lender said no big deal to damage"
  ],

  "2 Did not use PB" => [ #these are all manually set
    "Borrow from friend/family",
    "Borrow from neighbor",
    "Rent elsewhere",
    "Buy online",
    "Buy in-store",
    "Use good-enough alternative"
  ]
}

status_codes.each do |c, s|
  Statuscategory.create(name: c)
  s.each do |s|
    Statuscategory.find_by_name(c).statuses.create(name: s)
  end
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
  if c.include? "gear" #because the last 3 categories that are inventory_list only just happen to have gear, can be more specific here
    i.each do |i|
      Categorylist.find_by_name(c).itemlists.create(name: i, request_list: false, inventory_list: true)
    end
  else
    i.first(8).each do |i|
      Categorylist.find_by_name(c).itemlists.create(name: i, request_list: true, inventory_list: true)
    end
    temp = i - i.first(8)
    temp.each do |i|
      Categorylist.find_by_name(c).itemlists.create(name: i, request_list: false, inventory_list: true)
    end
  end
end