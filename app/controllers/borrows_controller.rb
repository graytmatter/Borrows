class BorrowsController < ApplicationController
  before_filter :authenticate
  
  def index
    @inventory_id_collection = Hash.new
    Borrow.select { |b| b.inventory_id.present? }.each do |b|
      if @inventory_id_collection.has_key?("#{Inventory.find_by_id(b.inventory_id).signup.email}")
        @inventory_id_collection["#{Inventory.find_by_id(b.inventory_id).signup.email}"] << b.inventory_id
      else
        @inventory_id_collection["#{Inventory.find_by_id(b.inventory_id).signup.email}"] = Array.new
        @inventory_id_collection["#{Inventory.find_by_id(b.inventory_id).signup.email}"] << b.inventory_id
      end
    end

    @inventory_id_collection.each do |k,v|
      @inventory_id_collection[k] = v*","
    end

    query = params[:q]
    query["inventory_id_eq_any"] = params[:q]["inventory_id_eq_any"].split(',') if query != nil
    @q = Borrow.ransack(query)
    @borrows = @q.result.includes(:request => :signup)
  end

  def edit
  	@borrow = Borrow.find(params[:id])
  end

  def update
  	@borrow = Borrow.find(params[:id])
  	
    if @borrow.update_attributes(borrow_params)
  		flash[:success] = "Update successful"
  		redirect_to '/admin/borrows'
  	else
  		render 'edit'
  	end
  end

  private

  def borrow_params
  	params.require(:borrow).permit(:status1, :status2, :inventory_id, request_attributes: [:id, :pickupdate, :returndate]) 
  end

end