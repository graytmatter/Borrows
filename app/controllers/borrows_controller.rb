class BorrowsController < ApplicationController
  before_filter :authenticate
  
  def index
    @q = Borrow.ransack(params[:q])
    @borrows = @q.result.includes(:request => :signup, :invenborrow => :inventory)
  end

  def edit
  	@borrow = Borrow.find(params[:id])
  end

  def update
  	@borrow = Borrow.find(params[:id])
  	
    if @borrow.update_attributes(borrow_params)
      if @borrow.status1 == 2 && params[:status1] == 1
        no_longer_no_longer_needed = Borrow.where({ itemlist_id: @borrow.itemlist_id, request_id: @borrow.request.id }).where.not(inventory_id: @borrow.inventory_id)
        no_longer_no_longer_needed.each { |b| b.update_attributes(status1: 1) }

        @borrow.update_attributes(status1: ) 
        
      # elsif original_status1 === 8..23 && params[:status1] == 1
      #   original_borrows = Borrow.where({itemlist_id: @borrow.itemlist_id, request_id: @borrow.request.id})
      #   original_borrows.each { |b| b.update_attributes(status1: 1) }
      end  
  		flash[:success] = "Update successful"
  		redirect_to '/admin/borrows'
  	else
  		render 'edit'
  	end
  end

  private

  def borrow_params
  	params.require(:borrow).permit(:status1, :status2, :itemlist_id, request_attributes: [:id, :pickupdate, :returndate]) 
  end

end