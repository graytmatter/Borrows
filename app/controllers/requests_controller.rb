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

  def create_borrow(requestrecord, itemlist_id, multiple, inventory_id, status)
    case status
      when "checking"
        status_id = 1
      when "not available"
        status_id = 20
    end
    newborrow = requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple, inventory_id: inventory_id, status1: status_id )
  end

  def times_to_create(quantity, matched_inventory_ids, itemlist_id)
    multiple_counter = 1
    quantity.times do
      matched_inventory_ids.each_with_index do |inventory_id, index|
        # If there exists borrows with that same inventory id and request id, i.e., the borrower requests multiple of same thing, then create the record with a default status of where lender already gave it out
        if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).present? 
          if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.present?
            if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.select { |b| b.request.signup.email.downcase == @requestrecord.signup.email.downcase }.present?
              if index == 0
                # not_available_borrow = create_borrow(@requestrecord, itemlist_id, multiple_counter, nil, "not available")
                repeat_borrow = Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.select { |b| b.request.signup.email.downcase == @requestrecord.signup.email.downcase }.first
                if Rails.env == "test"
                  RequestMailer.repeat_borrow(repeat_borrow, itemlist_id).deliver
                else
                  Repeatborrow.new.async.perform(repeat_borrow, itemlist_id)
                end     
              end
            else
              if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.select { |b| b.request.signup.email != @requestrecord.signup.email }.select { |b| ([2,3].include? b.status1) == false }.present? 
                if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.select { |b| ([2,3].include? b.status1) == true}.select { |b| b.inventory_id == inventory_id }.present?
                  if index == 0
                    not_available_borrow = create_borrow(@requestrecord, itemlist_id, multiple_counter, nil, "not available")
                    if Rails.env == "test"
                      RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
                    else
                      Notfound.new.async.perform(not_available_borrow, itemlist_id)
                    end  
                  end
                else
                  create_borrow(@requestrecord, itemlist_id, multiple_counter, inventory_id, "checking")
                end
              else
                if index == 0
                  not_available_borrow = create_borrow(@requestrecord, itemlist_id, multiple_counter, nil, "not available")
                  if Rails.env == "test"
                    RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
                  else
                    Notfound.new.async.perform(not_available_borrow, itemlist_id)
                  end  
                end
              end
            end
          else
            create_borrow(@requestrecord, itemlist_id, multiple_counter, inventory_id, "checking")
          end
        else
          create_borrow(@requestrecord, itemlist_id, multiple_counter, inventory_id, "checking")
        end
      end
    multiple_counter += 1
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
      if @requestrecord.id.present?
        @borrowparams.each do |itemlist_id, quantity|
          matched_inventory_ids = Inventory.where.not(signup_id: @requestrecord.signup.id).where(itemlist_id: itemlist_id).ids 
          if quantity.to_i > matched_inventory_ids.count
            difference = quantity.to_i - matched_inventory_ids.count
            multiple_counter = 0
            difference.times do 
              not_available_borrow = create_borrow(@requestrecord, itemlist_id, multiple_counter+quantity.to_i, nil, "not available")
              multiple_counter += 1
              if Rails.env == "test"
                RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
              else
                Notfound.new.async.perform(not_available_borrow, itemlist_id)
              end  
            end
            if Rails.env == "test"
              times_to_create(matched_inventory_ids.count, matched_inventory_ids, itemlist_id)
            else
              SuckerPunch::Queue[:creation_queue].async.perform(matched_inventory_ids.count, matched_inventory_ids, itemlist_id)
            end
          else
            if Rails.env == "test"
              times_to_create(quantity.to_i, matched_inventory_ids, itemlist_id) 
            else
              SuckerPunch::Queue[:creation_queue].async.perform(quantity.to_i, matched_inventory_ids, itemlist_id)
            end
          end
        end
        #right now the same day email sends even if all the borrows already are N/A, ideally this would only send if i need to ping the borrowers because items are indeed available
        if @requestrecord.pickupdate == Date.today
          if Rails.env == "test"
            RequestMailer.same_as_today(@requestrecord).deliver
          else
            Sameday.new.async.perform(@requestrecord)
            #throws errors because it appears the object is not being passed. in the mailer view, all the attributes like name or email are throwing no method errors for nil class
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
    @borrowparams = params["borrow"]
    @borrowparams = @borrowparams.first.reject { |k, v| (v == "") || ( v == "0" ) }
  end
end
