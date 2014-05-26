class RequestsController < ApplicationController

  def new
    @requestrecord = Request.new
    @requestrecord.email = session[:signup_email]
    inventory
    howto
    @pagetitle = "What would you like to borrow?"
  end

  def create
    @requestrecord = Request.new(request_params)
    inventory
    howto
    @pagetitle = "What would you like to borrow?"
=begin    
    if @requestrecord.paydeliver == false
      @requestrecord.addysdeliver = nil
      @requestrecord.timedeliver = nil
      @requestrecord.instrucdeliver = nil
    end
=end
    
    if @requestrecord.save
      flash[:success] = "Thanks! We'll send you an email to further coordinate (average response time is less than 1 hour). If you'd like to change your request, just modify the form below and submit again."
      # Comments from here use example of @requestrecord.items = ["water filter", "tent", "0", "0", "0"] where "0" represents blank checkboxes
      @requestrecord.items.select! { |x| x != "0" } #removes blank checkboxes; @requestrecord.items = ["water filter", "tent"]
      num_of_requests = @requestrecord.items.count #counts number of items requested; num_of_requests = 2

      i = 0 
      cloned_request = Hash.new
      while i < num_of_requests do
         cloned_request[i] = Marshal.load(Marshal.dump(@requestrecord)) #creates a cloned_request[0] = @requestrecord and cloned_request[1] = @requestrecord 
         cloned_request[i].items = @requestrecord.items.slice(i) #disaggregates the items into the cloned_requests; cloned_request[0].items = "water filter",  cloned_request[1].items = "tent" 
         i += 1
      end

      cloned_request.each do | key, request |
          request.save_spreadsheet
      end

      RequestMailer.confirmation_email(@requestrecord).deliver
      redirect_to edit_request_path(@requestrecord.edit_id)
    else
      render 'new'
    end
  end

  def edit 
    @requestrecord = Request.find_by_edit_id(params[:edit_id])
    inventory
    howto
    @pagetitle = "Update your request"
  end

  def update
    @requestrecord = Request.find_by_edit_id(params[:edit_id])
    inventory
    howto
    @pagetitle = "Update your request"
    @requestrecord.attributes = request_params

=begin
    if @requestrecord.paydeliver == false
      @requestrecord.addysdeliver = nil
      @requestrecord.timedeliver = nil
      @requestrecord.instrucdeliver = nil
    end
=end

    if @requestrecord.changed? && @requestrecord.save
      flash[:success] = "Your request has been updated! We'll respond in about 3 hours."
      RequestMailer.update_email(@requestrecord).deliver
      redirect_to edit_request_path(@requestrecord.edit_id)
    else
      render 'edit'
    end
  end

  private
    def request_params
      params.require(:request).permit(:email, {:items => []}, :detail, :name, :rentdate, :paydeliver, :addysdeliver, :timedeliver, :instrucdeliver, :edit_id, :heard)
    end

    def inventory
      @inventory = {
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