class RequestsController < ApplicationController

  def new
    itemlist
    @itemlist.first(6)
    @pagetitle = "What would you like to borrow?"

    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
      if @signup_parent.tos != true || @signup_parent.streetone.blank? || @signup_parent.streettwo.blank? || @signup_parent.zipcode.blank?
        flash[:danger] = "Almost there! We just need a little more info"
        redirect_to edit_signup_path
      else
        @requestrecord = @signup_parent.requests.build 
      end
    end
    
  end

  def create
    itemlist
    @itemlist.first(6)
    @pagetitle = "What would you like to borrow?"

    @signup_parent = Signup.find_by_email(session[:signup_email])
    request_params
    @requestrecord = @signup_parent.requests.build

    if @transactionparams.blank?
      @requestrecord.errors[:base] = "Please select at least one item"
      render 'new'
    else
      @requestrecord = @signup_parent.requests.create(@requestparams)
      if @requestrecord.save
        transactions_to_be_saved = []
        @transactionparams.each do |item, quantity|
        quantity = quantity.to_i
          quantity.times do
            transactions_to_be_saved << ({ :name => item })
          end
        end
        @requestrecord.transactions.create transactions_to_be_saved

        #saves to spreadsheet and sends email, delete later
        # @requestrecord.transactions.each do |t|
        #   t.save_spreadsheet
        # end
        @transactionparams.each do |item, quantity|
          #1) Select ids of inventory items that don't belong to borrower and match the transaction items
          @matched_inventory = Inventory.where.not(signup_id: @requestrecord.signup.id).where(item_name: item).ids 
          #2) Select (i.e., narrow down) to only the ids of inventory items that aren't associated with any transaction or are associated with a transaction but in a non competing time period
          @matched_inventory.select { |id| (Transaction.find_by_item_id(id) == nil)|| ( (@requestrecord.pickupdate - Transaction.find_by_item_id(id).request.returndate) * (Transaction.find_by_item_id(id).request.pickupdate - @requestrecord.returndate) ) < 0 }
          #3) Select the emails of those available inventory ids
          @lender_array = Inventory.where(id: @matched_inventory).joins(:signup).pluck("signups.email")
          #4) Email the lenders
          #system "rake connect_email rails_env = #{Rails.env} requestrecord = #{@requestrecord} lender_array = #{@lender_array} item = item quantity = quantity --trace >> #{Rails.root}/log/rake.log &"
          call_rake :connect_email, :requestrecord => @requestrecord, :lender_array => @lender_array, :item => item, :quantity => quantity
          #5) If the total number of inventory items matched was less than the quantity requested, let me know
          if @matched_inventory.count < quantity.to_i
            call_rake :not_found_email, :requestrecord => @requestrecord, :matched_inventory => @matched_inventory, :item => item, :quantity => quantity
          end
        end

        redirect_to action: 'success'
      else
        render 'new'
      end
    end
  end

  def success
  end

  private

  def request_params
    @requestparams = params.require(:request).permit(:detail, :pickupdate, :returndate) 
    @transactionparams = params["transaction"]
    @transactionparams = @transactionparams.first.reject { |k, v| (v == "") || ( v == "0" ) || ( v.length > 2 ) }
  end
end
