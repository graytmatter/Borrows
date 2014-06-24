class RequestsController < ApplicationController

  def new
    availableitems
    @pagetitle = "What would you like to borrow?"
    howto

    if session[:signup_email].nil?
      flash[:danger] = "You must enter an email on the home page to access the rest of the site"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
    end
    @requestrecord = @signup_parent.requests.build 
  end

  def create
    availableitems
    @pagetitle = "What would you like to borrow?"
    howto

    if session[:signup_email].nil?
      flash[:danger] = "You must enter an email on the home page to access the rest of the site"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
    end

    request_params
    @requestrecord = @signup_parent.requests.build(@requestparams)

    if @transactionparams.blank?
      @requestrecord.errors.add(:items, 'You must select at least one item')
      render 'new'
    else
      if @requestrecord.save
        transactions_to_be_saved = []
        @transactionparams.each do |item, quantity|
        quantity = quantity.to_i
          quantity.times do
            transactions_to_be_saved << ({:request_id => @requestrecord.id, :name => item })
          end
        end
        Transaction.create transactions_to_be_saved
        flash[:success] = "Thanks!"
        redirect_to edit_request_path(@requestrecord.edit_id)
      else
        render 'new'
      end
    end

    
    # if @requestrecord.save
    #   flash[:success] = "Thanks! We'll send you an email to further coordinate (average response time is less than 1 hour). If you'd like to change your request, just modify the form below and submit again."
    #   # Comments from here use example of @requestrecord.items = ["water filter", "tent", "0", "0", "0"] where "0" represents blank checkboxes
    #   @requestrecord.items.select! { |x| x != "0" } #removes blank checkboxes; @requestrecord.items = ["water filter", "tent"]
    #   num_of_requests = @requestrecord.items.count #counts number of items requested; num_of_requests = 2

    #   i = 0 
    #   cloned_request = Hash.new
    #   while i < num_of_requests do
    #      cloned_request[i] = Marshal.load(Marshal.dump(@requestrecord)) #creates a cloned_request[0] = @requestrecord and cloned_request[1] = @requestrecord 
    #      cloned_request[i].items = @requestrecord.items.slice(i) #disaggregates the items into the cloned_requests; cloned_request[0].items = "water filter",  cloned_request[1].items = "tent" 
    #      i += 1
    #   end

    #   cloned_request.each do | key, request |
    #       request.save_spreadsheet
    #   end

    #   RequestMailer.confirmation_email(@requestrecord).deliver
    #   redirect_to edit_request_path(@requestrecord.edit_id)

    # else
    #   render 'new'
    # end
  end

  def edit 
    availableitems
    @pagetitle = "What would you like to borrow?"
    howto

    @requestrecord = Request.find_by_edit_id(params[:edit_id])
    
  end

  def update
    availableitems
    @pagetitle = "What would you like to borrow?"
    howto

    @requestrecord = Request.find_by_edit_id(params[:edit_id])
    @requestrecord.attributes = @requestparams

    @requestrecord.transactions.delete_all
    transactions_to_be_saved = []
    @transactionparams.each do |item, quantity|
      quantity = quantity.to_i
      quantity.times do
        transactions_to_be_saved << ({:request_id => @requestrecord.id, :name => item })
      end
    end

    # if transactions_to_be_saved.blank?
    #   flash[:danger] = "You must select at least one item before submitting the form"
    #   render 'new'
    # else
      Transaction.create transactions_to_be_saved
      flash[:success] = "Thanks!"
      redirect_to edit_request_path(@requestrecord.edit_id)
    # end


=begin
    if @requestrecord.paydeliver == false
      @requestrecord.addysdeliver = nil
      @requestrecord.timedeliver = nil
      @requestrecord.instrucdeliver = nil
    end
=end

    if @requestrecord.changed? && @requestrecord.save
      flash[:success] = "Your request has been updated! We'll respond in about 3 hours."
      RequestMailer.update_email(@requestrecord).deliver
      redirect_to edit_request_path(@requestrecord.edit_id)
    else
      render 'edit'
    end
  end

  private

    def request_params
      params.require(:request).permit(:quantity, :detail, :startdate, :enddate, :addysdeliver, :heard)

      #almost there, but wanted to stop to try to see the "right" way of getting the data out
      @requestparams = params.require(:request).permit(:detail, :startdate, :enddate, :addysdeliver, :heard) #OPTION 1
      #@requestparams[:signup_id] = @signup_parent.id #OPTION 2

      #works will generate the proper hash
      @transactionparams = params["transaction"]
      @transactionparams = @transactionparams.first.reject { |k, v| v == "" }
    end

    def availableitems
      @availableitems = {
      "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter"],
      "Park & picnic" => ["Portable table", "Portable chair", "Cooler", "Outdoors grill", "Shade house"],
      "Tools" => ["Electric drill", "Screwdriver set", "Hammer", "Wrench set", "Utility knife"],
      "Housewares" => ["Vacuum", "Air mattress", "Iron & board", "Luggage", "Extension cords"], 
      #"Baby gear" => ["Umbrella Stroller", "Booster seat", "Backpack carrier", "Pack n' Play", "Jumper"],
      "Kitchenwares" =>["Blender", "Electric grill", "Food processor", "Baking dish", "Knife sharpener"],
      #"Snow sports" => ["Outerwear", "Innerwear", "Gloves" , "Helmet", "Goggles"]
      "Miscellaneous" => ["Tennis set", "Bike pump", "Jumper cables", "Dry bag", "Mat cutter"],
    }
    end
end