class RequestsController < ApplicationController

  def new
    itemlist
    @pagetitle = "What would you like to borrow?"

    if session[:signup_email].nil?
      flash[:danger] = "You must provide additional information first"
      redirect_to controller: 'signups', action: 'edit'
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
    end
    
    howto
    @requestrecord = @signup_parent.requests.build 
  end

  def create
    itemlist
    @pagetitle = "What would you like to borrow?"
    howto

    if session[:signup_email].nil?
      flash[:danger] = "You must enter an email on the home page to access the rest of the site"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
    end

    request_params
    @requestrecord = @signup_parent.requests.build

    if @transactionparams.blank?
      @requestrecord.errors[:base] = "Please select at least one item"
      render 'new'
    else
      @requestrecord = @signup_parent.requests.create(@requestparams)
      if @requestrecord.save
        transactions_to_be_saved = []
        @transactionparams.each do |item, quantity|
        quantity = quantity.to_i
          quantity.times do
            transactions_to_be_saved << ({:request_id => 0, :name => item })
          end
        end
        Transaction.create transactions_to_be_saved
        flash[:success] = "Thanks!"
        redirect_to action: 'success'
      else
        render 'new'
      end
    end
  end

  def index
  end

  def success
  end

  private

  def request_params
    @requestparams = params.require(:request).permit(:detail, :startdate, :enddate) 
    @transactionparams = params["transaction"]
    @transactionparams = @transactionparams.first.reject { |k, v| (v == "0") || (v == "")}
  end

  def itemlist
    @itemlist = {
    "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter"],
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
