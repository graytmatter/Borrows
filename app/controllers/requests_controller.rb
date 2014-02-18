class RequestsController < ApplicationController
  def new
    @requestrecord = Request.new
    @inventory = {
      "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter", "Hydration bladder"],
      "Housewares" => ["Air mattress", "Electric drill", "Suitcase", "Iron", "Blender", "Portable grill"],
      "Snow sports" => ["Outer shell (upper)", "Outer shell (lower)", "Insular mid-layer (upper)", "Insular mid-layer(lower)", "Helmet", "Goggles"],
      "City sports" => ["Tennis racket & balls", "Volleyball net & ball", "Football", "Bicycle", "Bicycle pump", "Bicycle helmet"]
    }
  end

  def create
    @requestrecord = Request.new(request_params)
    if @requestrecord.save
      flash[:success] = "Thanks, we'll respond in about one business day. Below is the information you submitted in case you need to change anything; we'll also email you a link to this page so you can update later."
      @requestrecord.save_spreadsheet
      RequestMailer.confirmation_email(@requestrecord, request.host_with_port).deliver
      redirect_to edit_request_path(@requestrecord.edit_id)
    else
      render 'new'
    end
  end

  def edit 
    @requestrecord = Request.find_by_edit_id(params[:edit_id])
  end

  def update
    @requestrecord = Request.find_by_edit_id(params[:edit_id])
    @requestrecord.attributes = request_params
    if @requestrecord.changed? && @requestrecord.save
      flash[:success] = "Your request has been updated! We'll respond within one business day."
      RequestMailer.update_email(@requestrecord, request.host_with_port).deliver
      redirect_to edit_request_path(@requestrecord.edit_id)
    else
      render 'edit'
    end
  end

  private
    def request_params
      params.require(:request).permit(:email, :item, :detail, :name, :edit_id)
    end
end
