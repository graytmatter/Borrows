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
        quantity.to_i.times do
          matched_inventory_ids.each do |inventory_id|
            # If there exists borrows with that same inventory id that is using PB, then check for date conflicts. Then if date conflicts, create the record with a default status of "Another borrower has it"
            if Borrow.find_by_inventory_id(inventory_id).select { |borrow| Status.where(statuscategory_id: Statuscategory.find_by_name("1 Did use PB")).pluck("id").include? borrow.status1 }
              Borrow.find_by_inventory_id(inventory_id).select { |borrow| Status.where(statuscategory_id: Statuscategory.find_by_name("1 Did use PB")).pluck("id").include? borrow.status1 }.each do |borrow|
                if borrow.do_dates_overlap(@requestrecord) == "yes"
                  newborrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, inventory_id: inventory_id, status1: Status.find_by_name("TC - Another Borrower has it").id)
                else
                  newborrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, inventory_id: inventory_id, status1: Status.find_by_name("Searching").id)
                end
              end
            else
              newborrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, inventory_id: inventory_id, status1: Status.find_by_name("Searching").id)
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
