class InventoriesController < ApplicationController
  #before_filter :authenticate, except: [:new, :create, :destroy]

  def new
    itemlist
    @pagetitle = "What would you like to lend?"
    
    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
    end

  end

  def create
    itemlist
    @pagetitle = "What would you like to lend?"

    @signup_parent = Signup.find_by_email(session[:signup_email])

    inventory_params
    
    items_to_be_saved = []
    @inventory_params.each do |item, quantity|
      quantity = quantity.to_i
      quantity.times do
        items_to_be_saved << ({:signup_id => @signup_parent.id, :item_name => item })
      end
    end

    if items_to_be_saved.blank?
      @signup_parent.errors[:base] << "Please select at least one item to lend"
      render 'new'
    else
      Inventory.create items_to_be_saved
      flash[:success] = "Thanks!"
      redirect_to new_inventory_path
    end
  end

  def index
    @q = Inventory.ransack(params[:q])
    @inventories = @q.result.includes(:signup)
  end

  def destroy
    Inventory.find(params[:id]).destroy
    if request.referer.include? 'admin'
      redirect_to :action => 'index'
    else
      redirect_to :action => 'new'
    end
  end

  private

    def inventory_params
      params.permit[:quantity]
      @inventory_params = params.reject { |k, v| (v == "") || ( v == "0" ) || ( v.length > 2 ) }
    end

    def itemlist
      @itemlist = {
      #9 items each
      "Camping" => ["Tent (1-person)", "Tent (2-person)", "Tent (3-person)", "Tent (4-person)", "Tent (6-person)", "Tent (8-person)", "Sleeping bag", "Sleeping pad", "Camp pillow", "Daypack", "Daypack cover"],
      "Backpacking" => ["Trekking poles", "Backpack", "Backpack cover", "Water filter", "Camp stove", "Camp cookware", "Bear canister", "Hammock", "Dry bag", "Headlamp", "Compass"],
      "Kitchenwares" =>["Blender", "Electric grill", "Food processor", "Baking dish", "Knife sharpener", "Springform cake pan", "Sandwich/panini press", "Rice cooker", "Immersion blender", "Hand/stand mixer", "Ice cream maker"],
      
      #7 items each
      "Park & picnic" => ["Portable table", "Portable chair", "Cooler", "Outdoors grill", "Shade house", "Portable lanterns", "Portable speakers"],
      "Snow sports gear" => ["Outerwear (top)", "Outerwear (bottom)", "Thermalwear (top)", "Thermalwear (bottom)", "Gloves" , "Helmet", "Goggles"],
      "Housewares" => ["Vacuum", "Air mattress", "Iron & board", "Luggage", "Extension cords", "Steam cleaner", "Sewing machine"], 
      "Tools" => ["Electric drill", "Screwdriver set", "Hammer", "Sliding wrench", "Utility knife", "Handsaw", "Jumper cables"],
      "Baby gear" => ["Umbrella Stroller", "Booster seat", "Carrier", "Pack n' Play", "Jumper", "Bassinet", "Carrier for backpacking"],
      "Sports gear" => ["Tennis set", "Volleyball set", "Bike helmet", "Bike pump", "Football", "Soccerball", "Basketball" ]
    }
    end
end