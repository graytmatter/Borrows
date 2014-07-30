class BorrowsController < ApplicationController
  before_filter :authenticate
  
  def index
    @q = Borrow.ransack(params[:q])
    @borrows = @q.result.includes(:request => :signup)

    @inventory_id_collection = Array.new
    Borrow.select { |b| b.inventory_id.present? }.each do |b|
      if @inventory_id_collection.select{ |c| c.first == "#{Inventory.find_by_id(b.inventory_id).signup.email}" }.present?
        @inventory_id_collection.select{ |c| c.first == "#{Inventory.find_by_id(b.inventory_id).signup.email}"}.first.second.push(b.inventory_id)
      else
        @inventory_id_collection << ["#{Inventory.find_by_id(b.inventory_id).signup.email}", [b.inventory_id]]
      end
    end

    # @inventory_id_collection = Hash.new
    # Borrow.select { |b| b.inventory_id.present? }.each do |b|
    #   if @inventory_id_collection.has_key?("#{Inventory.find_by_id(b.inventory_id).signup.email}")
    #     @inventory_id_collection["#{Inventory.find_by_id(b.inventory_id).signup.email}"] << b.inventory_id
    #   else
    #     @inventory_id_collection["#{Inventory.find_by_id(b.inventory_id).signup.email}"] = Array.new
    #     @inventory_id_collection["#{Inventory.find_by_id(b.inventory_id).signup.email}"] << b.inventory_id
    #   end
    # end

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