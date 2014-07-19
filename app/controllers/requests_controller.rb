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

    if @borrowparams.blank?
      @requestrecord.errors[:base] = "Please select at least one item"
      render 'new'
    else
      @requestrecord = @signup_parent.requests.create(@requestparams)
      @borrowparams.each do |itemlist_id, quantity|
        matched_inventory_ids = Inventory.where.not(signup_id: @requestrecord.signup.id).where(itemlist_id: itemlist_id).ids 
        # if someone's request exceeds inventory, you still want to create the borrows, but for the excess it doesn't matter at the moment because people will hopefully just decline them
        quantity.to_i.times do
          newborrow = @requestrecord.borrows.create(itemlist_id: itemlist_id) 
          matched_inventory_ids.each do |inventory_id|
            #check if inventory_id has already had an accepted request with conflicting dates, if so, do not associate it because the lender can't lend it out anyways
            Inventory.find_by_id(10).invenborrows.select { |invenborrow| invenborrow.accepted == true}.each do |accepted_invenborrow|
              if accepted_invenborrow.do_dates_overlap(@requestrecord) == "yes"
                newborrow.update_attributes(status: Status.find_by_name("not available").id)
              else # if it's "no" or on the "edge"
                newborrow.inventory_ids += inventory_id
              end
            end
          end
        end
      RequestMailer.same_as_today(@requestrecord).deliver if @requestrecord.pickupdate.to_date == Date.today
      end
      
      render 'success'
    end
  end


  def success
  end

  private

  def request_params
    @requestparams = params.require(:request).permit(:detail, :pickupdate, :returndate) 
    @borrowparams = params["borrow"]
    @borrowparams = @borrowparams.first.reject { |k, v| (v == "") || ( v == "0" ) }
  end
end
