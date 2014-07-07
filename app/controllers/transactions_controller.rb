class TransactionsController < ApplicationController
  before_filter :authenticate
  
  def index
  	statuscodes
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result.includes(:request => :signup)
  end

  def edit
  	statuscodes
  	@transaction = Transaction.find(params[:id])
  end

  def update
  	statuscodes
  	@transaction = Transaction.find(params[:id])
  	if @transaction.update_attributes(transaction_params)
  		flash[:success] = "Update successful"
  		redirect_to '/admin/transactions'
  	else
  		render 'edit'
  	end
  end

  def statuscodes
  	@statuscodes = {
	  "Working" => 1,
    "In progress" => 2,
    "Cancelled: No response from borrower" => 3,
    "Cancelled: No response from lender" => 4,
    "Cancelled: Time period too long" => 5,
    "Cancelled: No inventory available" => 6,
    "Cancelled: Borrowed instead" => 7,
    "Cancelled: Rented instead" => 8,
    "Cancelled: Bought instead" => 9,
    "Cancelled: Occasion for use cancelled" => 10,
    "Cancelled: Didn't actually need this item" => 11,
    "Complete: A-OK" => 12,
    "Complete: damages/repairs paid" => 13,
    "Complete: replacement paid" => 14
  	}
  end

  private

  def transaction_params
  	params.require(:transaction).permit(:status, :item_id, request_attributes: [:id, :pickupdate, :returndate]) 
  end

end