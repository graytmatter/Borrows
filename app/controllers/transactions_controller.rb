class TransactionsController < ApplicationController
  before_filter :authenticate
  
  def index
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result.includes(:request => :signup)
  end

end