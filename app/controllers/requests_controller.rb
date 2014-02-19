class RequestsController < ApplicationController
  def new
    @requestrecord = Request.new
    @inventory = {
      "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter", "Hydration bladder"],
      "Housewares" => ["Air mattress", "Electric drill", "Suitcase", "Vacuum", "Blender", "Portable grill"],
      "Outdoor activities" => ["Tennis rackets & balls", "Volleyball net & ball", "Bicycle pump", "Baseball bat, ball & glove", "Golf club & balls", "Cooler"],
      "Snow sports" => ["Outer shell (upper)", "Outer shell (lower)", "Insular mid-layer (upper)", "Insular mid-layer(lower)", "Helmet", "Goggles"]
      
    }
  end

  def create
    @requestrecord = Request.new(request_params)
    @inventory = {
      "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter", "Hydration bladder"],
      "Housewares" => ["Air mattress", "Electric drill", "Suitcase", "Vacuum", "Blender", "Portable grill"],
      "Outdoor activities" => ["Tennis rackets & balls", "Volleyball net & ball", "Bicycle pump", "Baseball bat, ball & glove", "Golf club & balls", "Cooler"],
      "Snow sports" => ["Outer shell (upper)", "Outer shell (lower)", "Insular mid-layer (upper)", "Insular mid-layer(lower)", "Helmet", "Goggles"]
      
    }
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
    @inventory = {
      "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter", "Hydration bladder"],
      "Housewares" => ["Air mattress", "Electric drill", "Suitcase", "Vacuum", "Blender", "Portable grill"],
      "Outdoor activities" => ["Tennis rackets & balls", "Volleyball net & ball", "Bicycle pump", "Baseball bat, ball & glove", "Golf club & balls", "Cooler"],
      "Snow sports" => ["Outer shell (upper)", "Outer shell (lower)", "Insular mid-layer (upper)", "Insular mid-layer(lower)", "Helmet", "Goggles"]
      
    }
  end

  def update
    @requestrecord = Request.find_by_edit_id(params[:edit_id])
    @inventory = {
      "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter", "Hydration bladder"],
      "Housewares" => ["Air mattress", "Electric drill", "Suitcase", "Vacuum", "Blender", "Portable grill"],
      "Outdoor activities" => ["Tennis rackets & balls", "Volleyball net & ball", "Bicycle pump", "Baseball bat, ball & glove", "Golf club & balls", "Cooler"],
      "Snow sports" => ["Outer shell (upper)", "Outer shell (lower)", "Insular mid-layer (upper)", "Insular mid-layer(lower)", "Helmet", "Goggles"]
      
    }
    @requestrecord.attributes = request_params
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
      params.require(:request).permit(:email, :item, :detail, :name, :rentdate, :paydeliver, :addysdeliver, :timedeliver, :instrucdeliver, :edit_id)
    end
end
