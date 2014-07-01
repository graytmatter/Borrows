class InventoriesController < ApplicationController
  before_filter :authenticate, except: [:new, :create, :destroy]

  def new
    itemlist
    @pagetitle = "What would you like to lend?"
    
    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
      @q = @signup_parent.inventories.ransack(params[:q])
      @inventories = @q.result.includes(:signup)
    end
  end

  def create
    itemlist
    @pagetitle = "What would you like to lend?"

    @signup_parent = Signup.find_by_email(session[:signup_email])
    @q = @signup_parent.inventories.ransack(params[:q])
    @inventories = @q.result.includes(:signup)
    # above required because when new is re-rendered, it's actually the create action 
    
    inventory_params
    
    items_to_be_saved = []
    @inventory_params.each do |item, quantity|
      quantity = quantity.to_i
      quantity.times do
        items_to_be_saved << ({:item_name => item })
      end
    end

    if items_to_be_saved.blank?
      @signup_parent.errors[:base] << "Please select at least one item to lend"
      render 'new'
    else
      @signup_parent.inventories.create items_to_be_saved
      flash[:success] = "Thank you so much! We'll be in touch when a borrower comes-a-knockin'!"
      
        @signup_parent.inventories.each do |i|
          i.save_spreadsheet
        end
        InventoryMailer.upload_email(@signup_parent, items_to_be_saved).deliver

      redirect_to new_inventory_path
    end
  end

  # def update
  #   @signup_parent = Signup.find_by_email(session[:signup_email])
  #   @q = @signup_parent.inventories.ransack(params[:q])
  #   @inventories = @q.result.includes(:signup)
  #   redirect_to :action => 'new'
  # end

  def index
    @q = Inventory.ransack(params[:q])
    @inventories = @q.result.includes(:signup)
  end

  def destroy
    @destroyed = Inventory.find(params[:id])
    Inventory.find(params[:id]).destroy
    if request.referer.include? 'admin'
      redirect_to :action => 'index'
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
      InventoryMailer.delete_email(@signup_parent, @destroyed).deliver
      redirect_to :action => 'new'
    end

    #Note currently these changes are not affecting spreadsheet!
  end

  private

    def inventory_params
      params.permit[:quantity]
      @inventory_params = params.reject { |k, v| (v == "") || ( v == "0" ) || ( v.length > 2 ) }
    end

    def itemlist
      @itemlist = {
      #13 items each
      "Camping" => ["Tent (1-Person)", "Tent (2-person)", "Tent (3-person)", "Tent (4-person)", "Tent (6-person)", "Tent (8-person)", "Tent (10-person)", "Sleeping bag", "Sleeping pad", "Camp pillow", "Daypack (<40L)", "Pack rain cover (<40L)", "Bear canister" ],
      "Backpacking" => ["Trekking poles", "Frame pack (80L+)", "Frame pack (60-80L)", "Frame pack (40-60L)", "Pack rain cover (80L+)", "Pack rain cover (60-80L)", "Pack rain cover (40-60L)", "Water purifier", "Camp stove", "Camp cookware", "Hammock", "Dry bag", "Headlamp"],
      "Kitchenwares" =>["Blender", "Electric grill", "Food processor", "Baking dish", "Knife sharpener", "Springform cake pan", "Sandwich/panini press", "Rice cooker", "Immersion blender", "Hand/stand mixer", "Ice cream maker", "Juicer", "Pressure Canner"],
      
      #8 items each
      "Park & picnic" => ["Portable table", "Portable chair", "Cooler", "Outdoors grill", "Shade house", "Portable lanterns", "Portable speakers", "Hammock"],
      "Housewares" => ["Vacuum", "Air mattress", "Iron & board", "Luggage (carry-on)", "Luggage (check-in)", "Extension cords", "Steam cleaner", "Sewing machine"], 
      "Tools" => ["Electric drill", "Screwdriver set", "Hammer", "Sliding wrench", "Utility knife", "Handsaw", "Jumper cables", "Level"],
      
      #7 items each
      "Snow sports gear" => ["Outerwear (top)", "Outerwear (bottom)", "Thermalwear (top)", "Thermalwear (bottom)", "Gloves" , "Helmet", "Goggles"],
      "Baby gear" => ["Umbrella Stroller", "Booster seat", "Carrier", "Pack n' Play", "Jumper", "Bassinet", "Carrier for backpacking"],
      "Sports gear" => ["Tennis set", "Volleyball set", "Bike helmet", "Bike pump", "Football", "Soccerball", "Basketball" ]
    }
    end
end