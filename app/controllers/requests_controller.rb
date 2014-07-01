class RequestsController < ApplicationController

  def new
    itemlist
    @pagetitle = "What would you like to borrow?"

    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
      
      @requestrecord = @signup_parent.requests.build 
    end
    
  end

  def create
    itemlist
    @pagetitle = "What would you like to borrow?"

    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
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
            transactions_to_be_saved << ({ :name => item })
          end
        end
        @requestrecord.transactions.create transactions_to_be_saved
        

        #saves to spreadsheet and sends email, delete later
        @requestrecord.transactions.each do |t|
          t.save_spreadsheet
        end
        RequestMailer.confirmation_email(@requestrecord).deliver


        redirect_to action: 'success'
      else
        render 'new'
      end
    end
  end

  def index
  end

  def success
    if session[:signup_email] != Request.last.signup.email
      flash[:danger] = "Please submit a request first"
      redirect_to new_request_path
    else
      @signup_parent = Request.last.signup
    end
  end

  private

  def request_params
    @requestparams = params.require(:request).permit(:detail, :pickupdate, :returndate) 
    @transactionparams = params["transaction"]
    @transactionparams = @transactionparams.first.reject { |k, v| (v == "") || ( v == "0" ) || ( v.length > 2 ) }
  end

  def itemlist
    @itemlist = {
    "Camping" => ["Tent for 2-3", "Tent for 4", "Sleeping bag", "Sleeping pad", "Daypack (<40L)", "Pack rain cover (<40L)"],
    "Park & picnic" => ["Portable table", "Portable chair", "Cooler", "Outdoors grill", "Shade house", "Hammock"],
    "Tools" => ["Electric drill", "Screwdriver set", "Hammer", "Sliding wrench", "Utility knife", "Mat cutter"],
    "Kitchenwares" =>["Blender", "Electric grill", "Food processor", "Baking dish", "Knife sharpener", "Juicer"],
    "Housewares" => ["Vacuum", "Air mattress", "Iron & board", "Luggage (carry-on)", "Luggage (check-in)", "Extension cords"], 
    "Backpacking" => ["Frame pack (80L+)", "Frame pack (60-80L)", "Dry bag", "Water filter", "Headlamp", "Camp stove"]
    #"Miscellaneous" => ["Tennis set", "Bike pump", "Jumper cables", "Dry bag", "Mat cutter"],
    #"Baby gear" => ["Umbrella Stroller", "Booster seat", "Backpack carrier", "Pack n' Play", "Jumper"],
    #"Snow sports" => ["Outerwear", "Innerwear", "Gloves" , "Helmet", "Goggles"]
    
  }
  end
end
