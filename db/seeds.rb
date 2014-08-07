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
    "Checking", #Default status, assumes that PB will help
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
    "TC - Not available", #Auto-set E.g., borrow already connected with lender
    "TC - Lender declined", #Auto-set E.g., lender cancels
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
  Statuscategory.find_or_create_by(name: c)
  s.each do |s|
    Statuscategory.find_by_name(c).statuses.find_or_create_by(name: s)
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
	Categorylist.find_or_create_by(name: c)
  if c.include? "gear" #because the last 3 categories that are inventory_list only just happen to have gear, can be more specific here
    i.each do |i|
      Categorylist.find_by_name(c).itemlists.find_or_create_by(name: i, request_list: false, inventory_list: true)
    end
  else
    i.first(8).each do |i|
      Categorylist.find_by_name(c).itemlists.find_or_create_by(name: i, request_list: true, inventory_list: true)
    end
    temp = i - i.first(8)
    temp.each do |i|
      Categorylist.find_by_name(c).itemlists.find_or_create_by(name: i, request_list: false, inventory_list: true)
    end
  end
end

# inventoryupdate = {
#   507 => {
#     1 => "http://www.amazon.com/Mountainsmith-Morrison-Person-Season-Citron/dp/B00452C2IC",
#     63 => "http://www.amazon.com/Guide-Gear-Portable-Folding-Hammock/dp/B003DQ2YIY/ref=cm_cr_pr_pb_t"
#   },
#   488 => {
#     64 => "",
#     59 => "https://www.google.com/shopping/product/4070470361165546655?q=amazon+portable+grill&client=safari&rls=en&bav=on.2,or.r_cp.r_qf.&bvm=bv.68191837,d.cGU,pv.xjs.s.en_US.0hJ7Oq-QgO0.O&biw=1264&bih=704&tch=1&ech=1&psi=woGLU-njMIewoQTioICABA.1401651651247.3&ei=3IGLU-71FNjpoAT_64DwDg&ved=0COIDEKYrMBA",
#     4 => "",
#     4 => "" RECREATE
#   },
#   37 => {
#     41 => "",
#     71 => ""
#   },
#   270 => {
#     30 => "9X9 pirex", RECREATE
#     30 => "9X9 pirex", RECREATE
#     30 => "9X13 pirex", RECREATE
#     30 => "Cookie sheets", RECREATE
#     30 => "Cupcake muffin full size",
#     27 => "",
#     29 => "",
#     32 => "",
#     33 => "",
#     35 => "8 inches",
#     35 => "9 inches", RECREATE
#     35 => "10 inches" RECREATE
#   },
#   495 => {
#     75 => "",
#     76 => "",
#     81 => ""
#   },
#   198 => {
#     60 => ""
#   },
#   48 => {
#     76 => "",
#     76 => "" RECREATE
#   },
#   190 => {
#     45 => "",
#     20 => ""
#   },
#   56 => {
#     42 => "",
#     36 => ""
#   },
#   217 => {
#     8 => "",
#     30 => "Cupcake/ muffins",
#     45 => "",
#     38 => "Handheld shaker",
#     36 => ""
#   },
#   510 => {
#     4 => ""
#   },
  # 345 => {
  #   2 => "Sierra Designs, no rain cover",
  #   1 => "http://www.rei.com/product/869082/kelty-discovery-2-tent",
  #   1 => "http://www.rei.com/product/869082/kelty-discovery-2-tent",
  #   1 => "http://www.rei.com/product/869082/kelty-discovery-2-tent",
  #   3 => "Kelty Ridgeway",
  #   19 => "http://www.rei.com/product/784149/sealline-black-canyon-dry-bag-20-liters",
  #   19 => "Small size to hold wallet/ phone",
  #   31 => "http://www1.macys.com/shop/product/wusthof-knife-sharpener-2-stage-handheld?ID=514547",
  #   59 => "",
  #   61 => "http://www.rei.com/product/829239/rei-flex-lite-chair?s_kwcid=sXwWSospt_dc%7Cpcrid%7C35471546165%7Cpkw%7Crei%20flex%20lite%20chair%7Cpmt%7Cp%7Cgoogle%7Cmain&gclid=CJTaufG32b4CFRNcfgodjQ8AGA",
  #   61 => "http://www.rei.com/product/829239/rei-flex-lite-chair?s_kwcid=sXwWSospt_dc%7Cpcrid%7C35471546165%7Cpkw%7Crei%20flex%20lite%20chair%7Cpmt%7Cp%7Cgoogle%7Cmain&gclid=CJTaufG32b4CFRNcfgodjQ8AGA",
  #   58 => "http://www.rei.com/product/794289/?cm_mmc=cse_PLA-_-pla_multichannel-_-product-_-7942890018&rei-screen-house,-sage/earth&preferredSku=7942890018&mr:trackingCode=51AD3FB2-C919-E011-8E88-001B21631C34&mr:referralID=NA&mr:device=c&mr:adType=pla_multichannel&mr:ad=52447406080&mr:keyword=&mr:match=&mr:filter=68532232360",
  #   58 => "http://www.rei.com/product/808943/kelty-cabana-large",
  #   4 => "http://www.amazon.com/Lafuma-Trek-Stretch-Sleeping-Bag/dp/B004DCPGUA/ref=pd_sxp_f_pt/185-5020236-1391456",
  #   4 => "http://www.walmart.com/ip/Coleman-Nimbus-Big-and-Tall-40-to-60-Degree-Adult-Sleeping-Bag/20594130",
  #   5 => "http://www.outdoorgearlab.com/Camping-Mattress-Reviews/REI-Trekker-1-75",
  #   17 => "",
  #   52 => "",
  #   43 => "", RECREATE
  #   43 => "",
  #   44 => "",
  #   61 => "",
  #   61 => "",
  #   4 => "",
  #   5 => "",
  #   14 => "http://backpacks.findthebest.com/l/396/REI-Mars-80",
  #   15 => "",
  #   7 => "",
  #   75 => "",
  #   76 => "",
  #   80 => "",
  #   81 => "",
  #   27 => "",
  #   3 => "http://www.rei.com/product/829184/rei-kingdom-4-tent",
  #   3 => "http://www.amazon.com/Grand-Trunk-Uinta-Quick-Tent/dp/B004O6XGUM",
  #   29 => "",
  #   20 => "",
  #   34 => "",
  #   4 => "Purple",
  #   4 => "Ozark trail"
#   },
#   511 => {
#     4 => "http://www.backpackinglight.com/cgi-bin/backpackinglight/forums/thread_display.html?forum_thread_id=83709"
#   },
#   502 => {
#     75 => "", RECREATE
#     75 => "",
#     67 => "",
#     14 => "http://www.kelty.com/p-658-red-cloud-90.aspx?category=backpacks",
#     1 => "http://www.rei.com/product/845478/rei-half-dome-2-tent",
#     5 => "http://www.outdoorgearlab.com/Sleeping-Pad-Womens-Reviews/REI-Lite-Core-1-5-Womens"
#   },
#   286 => {
#     30 => "Cupcake/ muffin", RECREATE
#     30 => "Regular",
#     49 => "",
#     50 => "",
#     51 => "",
#     35 => "",
#     17 => "",
#     61 => "",
#     43 => "",
#   },
#   189 => {
#     24 => "",
#     70 => "",
#     50 => "",
#     76 => "",
#     77 => ""
#   },
#   211 => {
#     16 => "",
#     50 => "",
#     53 => "",
#     61 => "", RECREATE
#     61 => "",
#     54 => "",
#     54 => "",
#     51 => ""
#   },
#   51 => {
#     18 => "",
#     4 => "", RECREATE
#     4 => "http://www.backpacker.com/gear-guide-2012-lafuma-extreme-600-sleeping-bag/gear/16384",
#     5 => "Thermarest"
#   },
#   282 => {
#     6 => "http://www.thisnext.com/item/2AFCBF0C/The-North-Face-Amira-Pack"
#   }, 
#   2 => {
#     70 => "",
#     71 => "",
#     80 => "",
#     54 => "",
#     5 => "",
#     40 => ""
#   },
#   505 => {
#     24 => "",
#     30 => ""
#   },
#   458 => {
#     27 => "",
#     45 => "",
#     50 => "",
#     42 => "",
#     51 => "",
#     54 => "",
#     40 => ""
#   },
#   203 => {
#     70 => "",
#     8 => "",
#     49 => "",
#     42 => "",
#     61 => "", RECREATE
#     61 => "",
#     62 => "",
#     67 => "",
#     40 => ""    
#   },
#   489 => {
#     71 => "",
#     49 => "",
#     67 => ""
#   },
#   504 => {
#     41 => "Full",RECREATE
#     41 => "Full",RECREATE
#     41 => "Queen", RECREATE
#     41 => "Queen",
#     1 => "",
#     65 => "",
#     61 => "Loveseat",
#     8 => ""
#   },
#   508 => {
#     1 => "",
#     62 => "Coleman",
#     59 => "Coleman",
#     4 => "",
#     4 => "", RECREATE
#     5 => "Car camping",RECREATE
#     5 => "Car camping"
#   },
#   509 => {
#     49 => ""
#   },
#   506 => {
#     5 => "",
#     5 => "", RECREATE
#     61 => "", RECREATE
#     61 => "",
#     1 => "",
#     64 => "",
#     8 => ""
#   },
#   33 => {
#     3 => "",
#     50 => "",
#     60 => ""
#   },
#   134 => {
#     16 => "",
#     50 => "",
#     21 => "http://www.avidmaxoutfitters.com/p-6186-eno-singlenest-hammock-charcoalroyal.aspx?CAWELAID=130003200000003753&CAGPSPN=pla&gclid=Cj0KEQjwxZieBRDegZuj9rzLt_ABEiQASqRd-uNuS1_vB-nxahywFM1FKkh2ovKUVGEl_dH7a8TImJ0aAh6u8P8HAQ",
#     20 => "",
#     32 => "",
#     5 => "Thermarest",
#     5 => "https://www.bigagnes.com/Products/Detail/Pad/InsulatedAirCore",
#     81 => ""
#   },
#   512 => {
#     79 => "",
#     81 => ""
#   }
# }

# inventoryupdate.each do |signup, item_descrip|
#   s = Signup.find(signup)
#   item_descrip.each do |itemlist_id, description|
#     s.inventories.create(itemlist_id: itemlist_id, description: description)
#   end
# end

# # }
# # Signup 345 = James DONE
# # Signup 11 = Lisa DONE
# # SIgnup 502 = Julia (new) DONE
# # Signup 134 = Zach DONE
# # Signup 203 = Rohit DONE
# # Signup 37 = Ayush - DONE
# # Signup 488 = ARi - DONE
# # Signup 189 = Libbie DONE
# # Signup 504 = Ted (new) DONE
# # Signup 489 = Sahir DONE
# # Signup 211 = Monty DONE
# # Signup 505 = Puja (new) DONE
# # Signup 286 = Ravi DONE
# # Signup 270 = Chelsea - DONE
# # Signup 2 = norna DONE
# # Signup 203 = Rohit DONE
# # Signup 458 = Rahim DONE
# # Signup 217 = Ginger DONE
# # Signup 51 = Michael (envirovadia) DONE
# # Signup 506 = Varun (new) DONE
# # Signup 507 = Adam camera (new) - DONE
# # Signup 508 = todd (new) DONE
# # Signup 33 = Wendy DONE
# # Signup 509 = justin (new) DONE
# # Signup 190 = Earl DONE
# # Sgnup 282 = Sharon DONE
# # Signup 56 = Elaina DONE
# # Signup 198 = Chris dale DONE
# # Signup 510 = heyisaak(new) DONE
# # Signup 511 = Joselyn (new) DONE
# # Signup 512 = jennifer zheng(new) DONE
# # Signup 495 = chenleslie DONE
# # Signup 48 = Dan DONE

# updateinventories = {
#   8=>24, 
# 21=>62, 
# 22=>8, 
# 25=>62, 
# 26=>83, 
# 28=>6, 
# 43=>64, 
# 44=>43, 
# 45=>44, 
# 58=>1, 
# 60=>22, 
# 61=>22, 
# 64=>9, 
# 65=>11, 
# 67=>8, 
# 69=>64, 
# 70=>64, 
# 71=>58, 
# 75=>80, 
# 76=>89
# }

# updateinventories.each do |k,v|
#   Inventory.find(k).update_attributes(itemlist_id: v)
# end

# updateinventories.each do |k,v|
#   puts "#{k} + #{v}"
# end



# update_borrows = {
#   99=>1, 
# 2=>45, 
# 100=>5, 
# 101=>61, 
# 102=>16, 
# 103=>20, 
# 104=>60, 
# 105=>59, 
# 114=>1, 
# 115=>4, 
# 116=>4, 
# 117=>4, 
# 118=>3, 
# 119=>4, 
# 120=>4, 
# 121=>4, 
# 122=>5, 
# 123=>5, 
# 124=>5, 
# 125=>41, 
# 126=>41, 
# 127=>20, 
# 128=>20, 
# 259=>49, 
# 260=>54, 
# 140=>4, 
# 141=>5, 
# 142=>5, 
# 143=>5, 
# 144=>60, 
# 145=>61, 
# 146=>58, 
# 147=>20, 
# 148=>20, 
# 149=>64, 
# 150=>1, 
# 151=>4, 
# 152=>64, 
# 153=>1, 
# 154=>4, 
# 155=>4, 
# 156=>5, 
# 157=>5, 
# 261=>50, 
# 262=>51, 
# 265=>3, 
# 266=>4, 
# 267=>4, 
# 268=>64, 
# 269=>59, 
# 270=>41, 
# 271=>20, 
# 272=>8, 
# 273=>1, 
# 274=>5, 
# 275=>5, 
# 75=>1, 
# 76=>1, 
# 77=>3, 
# 78=>3, 
# 79=>4, 
# 80=>4, 
# 81=>4, 
# 82=>4, 
# 83=>4, 
# 84=>4, 
# 85=>5, 
# 86=>5, 
# 87=>5, 
# 88=>5, 
# 89=>5, 
# 90=>5, 
# 91=>6, 
# 92=>6, 
# 93=>6, 
# 94=>63, 
# 95=>63, 
# 96=>41, 
# 97=>41, 
# 98=>41, 
# 327=>1, 
# 328=>3, 
# 329=>5, 
# 330=>5, 
# 331=>61, 
# 332=>61, 
# 333=>61, 
# 334=>61, 
# 335=>63, 
# 336=>28, 
# 337=>4, 
# 183=>60, 
# 184=>58, 
# 185=>8, 
# 338=>5, 
# 339=>61, 
# 340=>64, 
# 341=>49, 
# 342=>1, 
# 343=>4, 
# 344=>5, 
# 345=>16, 
# 346=>3, 
# 347=>4, 
# 348=>4, 
# 276=>1, 
# 277=>5, 
# 278=>5, 
# 279=>1, 
# 280=>8, 
# 281=>1, 
# 282=>58, 
# 283=>8, 
# 284=>4, 
# 285=>6, 
# 286=>33, 
# 287=>3, 
# 288=>5, 
# 289=>58, 
# 290=>63, 
# 291=>20, 
# 292=>1, 
# 293=>5, 
# 294=>16, 
# 295=>17, 
# 296=>3, 
# 297=>5, 
# 298=>5, 
# 299=>61, 
# 300=>61, 
# 301=>64, 
# 302=>59, 
# 303=>41, 
# 304=>41, 
# 305=>61, 
# 306=>61, 
# 307=>8, 
# 308=>1, 
# 309=>4, 
# 310=>5, 
# 311=>61, 
# 312=>20, 
# 313=>27, 
# 314=>29, 
# 315=>3, 
# 316=>3, 
# 317=>61, 
# 318=>61, 
# 319=>1, 
# 320=>3, 
# 321=>61, 
# 322=>61, 
# 323=>61, 
# 324=>61, 
# 325=>63, 
# 326=>20, 
# 349=>5, 
# 350=>5, 
# 351=>60, 
# 352=>61, 
# 353=>61, 
# 354=>58, 
# 355=>4, 
# 356=>4, 
# 357=>5, 
# 358=>5, 
# 359=>5, 
# 360=>3, 
# 361=>3, 
# 362=>60, 
# 363=>60, 
# 364=>61, 
# 365=>61, 
# 366=>64, 
# 367=>64, 
# 368=>58, 
# 369=>41, 
# 370=>41, 
# 371=>8, 
# 372=>59, 
# 373=>45, 
# 374=>45, 
# 375=>1, 
# 376=>4, 
# 377=>61, 
# 378=>4, 
# 379=>5, 
# 380=>8, 
# 381=>1, 
# 382=>4, 
# 383=>4, 
# 384=>5, 
# 385=>41, 
# 386=>1, 
# 387=>5, 
# 388=>61, 
# 389=>61, 
# 391=>1, 
# 392=>4, 
# 393=>4, 
# 394=>5, 
# 395=>5, 
# 396=>41, 
# 397=>4, 
# 398=>6, 
# 399=>61, 
# 400=>63, 
# 401=>1, 
# 402=>1, 
# 403=>59, 
# 404=>63, 
# 405=>1, 
# 406=>4, 
# 407=>5, 
# 408=>20, 
# 409=>8, 
# 410=>3, 
# 411=>63, 
# 412=>41, 
# 413=>41, 
# 414=>3, 
# 415=>61, 
# 416=>61, 
# 417=>61, 
# 418=>61, 
# 419=>58, 
# 420=>63, 
# 421=>3, 
# 422=>5, 
# 423=>5, 
# 424=>58, 
# 425=>63, 
# 426=>20, 
# 427=>20, 
# 428=>5, 
# 429=>8, 
# 430=>1, 
# 431=>1, 
# 432=>19, 
# 433=>19, 
# 434=>5, 
# 435=>5, 
# 436=>5, 
# 437=>5, 
# 438=>58, 
# 439=>8, 
# 440=>4, 
# 441=>5, 
# 442=>5, 
# 443=>5, 
# 444=>16, 
# 445=>16, 
# 447=>4, 
# 448=>5, 
# 449=>64, 
# 450=>41, 
# 451=>20, 
# 452=>8, 
# 446=>3, 
# 453=>1, 
# 454=>4, 
# 455=>5, 
# 456=>58, 
# 457=>1, 
# 458=>63, 
# 460=>3, 
# 461=>61, 
# 462=>61, 
# 463=>61, 
# 464=>61, 
# 465=>63, 
# 466=>63, 
# 467=>3, 
# 468=>3, 
# 469=>4, 
# 470=>4, 
# 471=>61, 
# 472=>61, 
# 473=>61, 
# 474=>61, 
# 475=>59, 
# 476=>58, 
# 477=>41, 
# 478=>41, 
# 479=>41, 
# 459=>3, 
# 480=>3, 
# 481=>49, 
# 482=>3, 
# 483=>3, 
# 484=>4, 
# 485=>4, 
# 486=>4, 
# 487=>4, 
# 488=>4, 
# 490=>8, 
# 491=>33, 
# 489=>3, 
# 492=>3, 
# 493=>4, 
# 494=>4, 
# 495=>4, 
# 496=>5, 
# 497=>5, 
# 498=>5, 
# 499=>5, 
# 500=>59, 
# 501=>41, 
# 502=>41, 
# 503=>58, 
# 504=>60, 
# 505=>59, 
# 506=>4, 
# 507=>4, 
# 508=>6, 
# 509=>59, 
# 510=>63, 
# 511=>20, 
# 512=>1, 
# 513=>4, 
# 514=>4, 
# 515=>64, 
# 517=>5, 
# 518=>61, 
# 519=>59, 
# 520=>58, 
# 523=>61, 
# 524=>58, 
# 525=>3, 
# 526=>64, 
# 527=>3, 
# 528=>59, 
# 529=>3, 
# 530=>5, 
# 531=>5, 
# 532=>60, 
# 533=>64, 
# 534=>41, 
# 535=>20, 
# 536=>3, 
# 537=>4, 
# 538=>4, 
# 539=>4, 
# 540=>4, 
# 541=>5, 
# 542=>5, 
# 543=>5, 
# 544=>5, 
# 545=>3, 
# 546=>61, 
# 547=>64, 
# 548=>63, 
# 549=>41, 
# 550=>61, 
# 551=>61, 
# 552=>61, 
# 553=>3, 
# 554=>64, 
# 555=>8, 
# 556=>58, 
# 557=>8
# }

# update_borrows.each do |k,v|
#   Borrow.find(k).update_attributes(itemlist_id: v)
# end

#Effective Date for terms of Service 
Tos.find_or_create_by(date: Time.local(2014, 7, 16))







