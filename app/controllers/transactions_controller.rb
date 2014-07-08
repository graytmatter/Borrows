class TransactionsController < ApplicationController
  before_filter :authenticate
  
  def index
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result.includes(:request => :signup)
  end

  def edit
  	@transaction = Transaction.find(params[:id])
  end

  def update
  	@transaction = Transaction.find(params[:id])
  	if @transaction.update_attributes(transaction_params)
  		flash[:success] = "Update successful"
  		redirect_to '/admin/transactions'
  	else
  		render 'edit'
  	end
  end

  private

  def transaction_params
  	params.require(:transaction).permit(:status, :item_id, request_attributes: [:id, :pickupdate, :returndate]) 
  end

end