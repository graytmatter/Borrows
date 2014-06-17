class InventoriesController < ApplicationController
  def new
    wishlist
    @pagetitle = "What would you like to lend?"

    @itemrecord = Inventory.new
  end

  def create
    wishlist
    @pagetitle = "What would you like to borrow?"
    
    items_to_offer = []
    inventory_params.each do |item|
      items_to_offer <<({ :user_id => Signup.find_by_email(:signup_email), :item_name => item })
    end
    if Inventory.create items_to_offer
      flash[:success] = "Thanks so much for helping your community! We'll be in touch when someone needs your item(s)."
      # Comments from here use example of @requestrecord.items = ["water filter", "tent", "0", "0", "0"] where "0" represents blank checkboxes
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  def destroy
    @inventory.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

  private
    def inventory_params
      params.require(:inventory).permit(:item_name)
    end

    def wishlist
      @wishlist = {
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