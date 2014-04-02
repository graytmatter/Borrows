class RequestsController < ApplicationController
http_basic_authenticate_with :name => "borrower", :password => "bigmooch"
#before_action :verify_entry_code, :only=>[:new, :create]

  def new
    @requestrecord = Request.new
    inventory
    @pagetitle = "What would you like to borrow?"
  end

  def create
    @requestrecord = Request.new(request_params)
    inventory
    @pagetitle = "What would you like to borrow?"
=begin    
    if @requestrecord.paydeliver == false
      @requestrecord.addysdeliver = nil
      @requestrecord.timedeliver = nil
      @requestrecord.instrucdeliver = nil
    end
=end
    
    if @requestrecord.save
      flash[:success] = "Thanks, we'll respond in a few hours. Below is the information you submitted in case you need to change anything."
      @requestrecord.save_spreadsheet
      RequestMailer.confirmation_email(@requestrecord).deliver
      redirect_to edit_request_path(@requestrecord.edit_id)
    else
      render 'new'
    end
  end

  def edit 
    @requestrecord = Request.find_by_edit_id(params[:edit_id])
    inventory
    @pagetitle = "Update your request"
  end

  def update
    @requestrecord = Request.find_by_edit_id(params[:edit_id])
    inventory
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
      flash[:success] = "Your request has been updated! We'll respond in a few hours."
      RequestMailer.update_email(@requestrecord).deliver
      redirect_to edit_request_path(@requestrecord.edit_id)
    else
      render 'edit'
    end
  end

  private
    def request_params
      params.require(:request).permit(:email, {:items => []}, :detail, :name, :rentdate, :paydeliver, :addysdeliver, :timedeliver, :instrucdeliver, :edit_id)
    end

    def inventory
      @inventory = {
      "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter"],
      "Sports & outdoors" => ["Tennis set", "Volleyball set", "Bicycle pump", "Portable grill", "Cooler"],
      "Tools" => ["Electric drill", "Screwdriver set", "Hammer", "Wrench set", "Vacuum"],
      "Home & kitchen" => ["Vacuum", "Air mattress", "Blender", "Electric grill", "Food processor"],
      "Baby gear" => ["Umbrella Stroller", "Booster seat", "Backpack carrier", "Pack n' Play", "Jumper"],
      "Snow sports" => ["Outerwear", "Innerwear", "Gloves" , "Helmet", "Goggles"]
    }
    end
end
