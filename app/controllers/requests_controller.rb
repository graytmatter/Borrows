class RequestsController < ApplicationController

  def new
    @pagetitle = "What would you like to borrow?"

    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email].downcase)
      if @signup_parent.tos != true || @signup_parent.streetone.blank? || @signup_parent.streettwo.blank? || @signup_parent.zipcode.blank?
        flash[:danger] = "Almost there! We just need a little more info"
        redirect_to edit_signup_path
      else
        @requestrecord = @signup_parent.requests.build 
      end
    end
    
  end

  def create
    @pagetitle = "What would you like to borrow?"

    @signup_parent = Signup.find_by_email(session[:signup_email].downcase)
    request_params
    @requestrecord = @signup_parent.requests.build

    if @transactionparams.blank?
      @requestrecord.errors[:base] = "Please select at least one item"
      render 'new'
    else
      @requestrecord = @signup_parent.requests.create(@requestparams)
      if @requestrecord.save
        @transactionparams.each do |itemlist_id, quantity|
          # 1) Create X number of transactions and remember that transaction_ids that were created
          current_transactions = []
          quantity.to_i.times do 
            @requestrecord.transactions.create(itemlist_id: itemlist_id) 
            current_transactions << Transaction.last.id 
          end
          if @requestrecord.pickupdate.to_date == Date.today
            # 2) If it's a last minute request, I will handle it manually, to avoid pissing off too many lenders
            RequestMailer.same_as_today(@requestrecord).deliver
          else
            # 2) Select ids of inventory items that don't belong to borrower and match the transaction items
            matched_inventory_id = Inventory.where.not(signup_id: @requestrecord.signup.id).where(itemlist_id: itemlist_id).ids 
            #matched_inventory_id = Inventory.where.not(signup_id: @requestrecord.signup.id)
            puts "INSPECT"
            puts matched_inventory_id.inspect
            puts matched_inventory_id.count.inspect 
            puts "END"

            # 3) Narrow down to ids of inventory items where itemlist_id of inventory item matches itemlist_id of transaction
            
            matched_inventory_id.select { |id| Inventory.where(itemlist_id: itemlist_id) }
            #matched_inventory_id = Inventory.where.not(signup_id: @requestrecord.signup.id)
            puts "INSPECT"
            puts matched_inventory_id.inspect
            puts matched_inventory_id.count.inspect 
            puts "END"

            # 4) Narrow down to ids of inventory items where date of current transaction and date of logged transaction do not overlap

            matched_inventory_id.select { |id| ( ((@requestrecord.pickupdate - Transaction.find_by_inventory_id(id).request.returndate) * (Transaction.find_by_inventory_id(id).request.pickupdate - @requestrecord.returndate)) < 0 ) }
            puts "INSPECT"
            puts matched_inventory_id.inspect
            puts matched_inventory_id.count.inspect 
            puts "END"
            #   (Transaction.find_by_inventory_id(id) == nil) 
            #   || 
            #   ( ((@requestrecord.pickupdate - Transaction.find_by_inventory_id(id).request.returndate) * (Transaction.find_by_inventory_id(id).request.pickupdate - @requestrecord.returndate)) < 0 )
            # }
            # 4) For remaining available ids, temporarily block them out 
            current_transactions.each do |transaction_id|
              Transaction.find_by_id(transaction_id).update_attributes(inventory_id: matched_inventory_id)
            end
            # 5) Select the emails of those available inventory ids
            lender_array = Inventory.where(id: matched_inventory_id).joins(:signup).pluck("signups.email")
            # 6) Email the lenders and ask for permission
            # system "rake connect_email rails_env = #{Rails.env} requestrecord = #{@requestrecord} lender_array = #{@lender_array} item = item quantity = quantity --trace >> #{Rails.root}/log/rake.log &"
            # call_rake :connect_email, :requestrecord => @requestrecord, :lender_array => @lender_array, :item => item, :quantity => quantity
            RequestMailer.found_email(@requestrecord, lender_array, itemlist_id, quantity).deliver unless lender_array.blank?
            # 7) ALERT me if the total number of inventory items matched was less than the quantity requested
            RequestMailer.not_found_email(@requestrecord, matched_inventory_id, itemlist_id, quantity).deliver if matched_inventory_id.count < quantity.to_i
          end
        end
        render 'success'
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
    @transactionparams = @transactionparams.first.reject { |k, v| (v == "") || ( v == "0" ) }
  end
end
