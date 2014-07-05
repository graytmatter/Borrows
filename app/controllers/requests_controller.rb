class RequestsController < ApplicationController

  def new
    itemlist
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
        #RequestMailer.confirmation_email(@requestrecord).deliver
        #will replace RequestMailer above

        @transactionparams.each do |item, quantity|
          @available_items = Hash.new
          @matched_inventory = Inventory.where.not(signup_id: item.request.signup.id).where(item_name: item.name).ids
          @matched_inventory.each do |inventory|
            if Transaction.find_by_item_id(inventory) == nil
              @available_items[item] = quantity
            else
              if ( (item.request.pickupdate - Transaction.find_by_item_id(inventory).request.returndate) * (Transaction.find_by_item_id(inventory).request.pickupdate - item.request.returndate) ) < 0 
                @available_items[item] = quantity
              end
            end
          end
          if @available_items.blank?
            RequestMailer.not_found_email(@requestrecord, t).deliver
          else
            @lender_array = []
            @available_items.each do |i, q|
              @lender_array << Inventory.find_by_id(i).signup.email
            end
            RequestMailer.found_email(@lender_array, item, quantity).deliver
          end
        end

        # @requestrecord.transactions.each do |t|
        #   @available_items = []
        #   @matched_items = Inventory.where.not(signup_id: t.request.signup.id).where(item_name: t.name).ids
        #   puts "INSPECT, expect below to be an array of matched item_ids"
        #   puts @matched_items.inspect 
        #   puts "END"
        #   @matched_items.each do |item|
        #     if Transaction.find_by_item_id(item) == nil
        #         @available_items << item
        #     else
        #       if ( (t.request.pickupdate - Transaction.find_by_item_id(item).request.returndate) * (Transaction.find_by_item_id(item).request.pickupdate - t.request.returndate) ) < 0 
        #         @available_items << item
        #       end
        #     end
        #   end
        #   puts "INSPECT, expect below to be an array of available item_ids"
        #   puts @available_items.inspect 
        #   puts "END"
        #   if @available_items.blank?
        #     RequestMailer.not_found_email(@requestrecord, t).deliver
        #   else
        #     @lender_array = []
        #     @available_items.each do |item|
        #       @lender_array << Inventory.find_by_id(item).signup.email
        #     end
        #     puts "INSPECT lender array"
        #     puts @lender_array.inspect
        #     puts "END"
        #     RequestMailer.found_email(@lender_array, t).deliver
        #   end
        # end

        redirect_to action: 'success'
      else
        render 'new'
      end
    end
  end

  def index
  end

  def success
  end

  private

  def request_params
    @requestparams = params.require(:request).permit(:detail, :pickupdate, :returndate) 
    @transactionparams = params["transaction"]
    @transactionparams = @transactionparams.first.reject { |k, v| (v == "") || ( v == "0" ) || ( v.length > 2 ) }
  end

  def itemlist
    @itemlist = {
    "Camping" => ["Tent (2-person)", "Tent (3-person)", "Tent (4-person)", "Sleeping bag", "Sleeping pad", "Daypack (<40L)", "Pack rain cover (<40L)"],
    "Park & picnic" => ["Portable table", "Portable chair", "Cooler", "Outdoors grill", "Shade house", "Portable lantern", "Hammock"],
    "Tools" => ["Electric drill", "Screwdriver set", "Hammer", "Sliding wrench", "Utility knife", "Yardstick", "Measuring tape"],
    "Kitchenwares" =>["Blender", "Electric grill", "Food processor", "Baking dish", "Knife sharpener", "Juicer", "Rice cooker"],
    "Housewares" => ["Vacuum", "Air mattress", "Iron & board", "Luggage (carry-on)", "Luggage (check-in)", "Extension cords", "Jumper cables"], 
    "Backpacking" => ["Frame pack (80L+)", "Frame pack (60-80L)", "Dry bag", "Water purifier", "Headlamp", "Camp stove", "One person bug net"]
    #"Miscellaneous" => ["Tennis set", "Bike pump", "Jumper cables", "Dry bag", "Mat cutter"],
    #"Baby gear" => ["Umbrella Stroller", "Booster seat", "Backpack carrier", "Pack n' Play", "Jumper"],
    #"Snow sports" => ["Outerwear", "Innerwear", "Gloves" , "Helmet", "Goggles"]
    
  }
  end
end
