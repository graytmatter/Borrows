class BorrowsController < ApplicationController
  before_filter :authenticate
  
  def index
    @q = Borrow.ransack(params[:q])
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
  	params.require(:borrow).permit(:status1, :status2, :itemlist_id, request_attributes: [:id, :pickupdate, :returndate]) 
  end

end