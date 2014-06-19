class InventoriesController < ApplicationController

  def new
    wishlist
    @pagetitle = "What would you like to lend?"
    @signup_parent = Signup.find_by_email(session[:signup_email])
    @itemrecord = @signup_parent.inventories.build
  end

  def create
    wishlist
    @pagetitle = "What would you like to lend?"
    
    # @signup_parent = Signup.find_by_email(session[:signup_email])
    
    # params[":item_name"].each do |item|
    #   @signup_parent.inventories.build(:signup_id => params[:signup_id], :item_name => item)
    # end

    # redirect_to new_inventory_path

    items_to_be_saved = []
    inventory_params.each do |i|
        items_to_be_saved << ({ :signup_id => Signup.find_by_email(session[:signup_email]).id, :item_name => i })
    end

    if Inventory.create items_to_be_saved
        flash[:success] = "Thanks!"
        redirect_to root_path
    else
        render new_inventory_path
    end

  end

  def destroy
    @inventory.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

  private

    def inventory_params
      #params.require(:inventory).permit({:item_name => []})
      #params.permit! #(:signup_id, {:item_name => []})
      params.require(":item_name")
    end

    # def submitted_email
    #   params.require(:signup_parent).permit(:email)
    # end

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