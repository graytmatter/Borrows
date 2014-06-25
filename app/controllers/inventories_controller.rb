class InventoriesController < ApplicationController

  def new
    itemlist
    @pagetitle = "What would you like to lend?"
    
    if session[:signup_email].nil?
      flash[:danger] = "You must provide additional information first"
      redirect_to controller: 'signups', action: 'edit'
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
      @inventory_params = params.reject { |k, v| v == "" }
    end

    def itemlist
      @itemlist = {
      "Camping" => ["Tent (2-person)", "Tent (3-person)", "Tent (4-person)", "Tent (6-person)", "Tent (8-person)", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter"],
      "Park & picnic" => ["Portable table", "Portable chair", "Cooler", "Outdoors grill", "Shade house"],
      "Tools" => ["Electric drill", "Screwdriver set", "Hammer", "Wrench set", "Utility knife"],
      "Housewares" => ["Vacuum", "Air mattress", "Iron & board", "Luggage", "Extension cords"], 
      #"Baby gear" => ["Umbrella Stroller", "Booster seat", "Backpack carrier", "Pack n' Play", "Jumper"],
      "Kitchenwares" =>["Blender", "Electric grill", "Food processor", "Baking dish", "Knife sharpener"],
      #"Snow sports" => ["Outerwear", "Innerwear", "Gloves" , "Helmet", "Goggles"]
      "Miscellaneous" => ["Tennis set", "Bike pump", "Jumper cables", "Dry bag", "Mat cutter"],
    }
    end
end