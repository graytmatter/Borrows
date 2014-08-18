class InventoriesController < ApplicationController

  before_filter :authenticate, except: [:new, :create, :destroy, :toggle, :destroy_description, :update, :manage, :accept, :decline, :create_borrow]

  def new
    @pagetitle = "What would you like to lend?"

    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email].downcase)
      if @signup_parent.tos != true || @signup_parent.streetone.blank? || @signup_parent.streettwo.blank? || @signup_parent.zipcode.blank?
        flash[:danger] = "Almost there! We just need a little more info"
        redirect_to edit_signup_path
      else
        @q = @signup_parent.inventories.ransack(params[:q])
        @inventories = @q.result.includes(:signup)
      end
    end
  end

  def create
    @pagetitle = "What would you like to lend?"

    @signup_parent = Signup.find_by_email(session[:signup_email].downcase)
    @q = @signup_parent.inventories.ransack(params[:q])
    @inventories = @q.result.includes(:signup)
    # above required because when new is re-rendered, it's actually the create action 
    
    inventory_params
    if @inventory_params.blank?
      @signup_parent.errors[:base] << "Please select at least one item to lend"
      render 'new'
    else
      @inventory_params.each do |itemlist_id, quantity|
        quantity.to_i.times do

          @new_inventory = @signup_parent.inventories.create(itemlist_id: itemlist_id, available: true)
          similar_borrows = Borrow.where(status1: 1, itemlist_id: itemlist_id).includes(:request => :signup)
          if similar_borrows.select{ |b| b.request.signup.email != @new_inventory.signup.email}.select { |b| Geography.find_by_zipcode(b.request.signup.zipcode).county == Geography.find_by_zipcode(@new_inventory.signup.zipcode).county}.count > 0
            existing_request = Array.new
            similar_borrows.select { |b| Geography.find_by_zipcode(b.request.signup.zipcode).county == Geography.find_by_zipcode(@new_inventory.signup.zipcode).county}.each { |b| existing_request << b.request_id }
            existing_request.uniq!
            existing_request.each do |r|
              Borrow.where(request_id: r, itemlist_id: itemlist_id, status1: 1).pluck("multiple").uniq.each do |m|
                Request.find_by_id(r).borrows.create(itemlist_id: itemlist_id, multiple: m, status1: 1, inventory_id: @new_inventory.id)
              end
            end
          end
        end
      end
      flash[:success] = "Thank you so much! We'll be in touch when a borrower comes-a-knockin'!"
      # @signup_parent.inventories.each do |i|
      #   i.save_spreadsheet
      # end
      # InventoryMailer.upload_email(@signup_parent, items_to_be_saved).deliver
      # soon inventorymailer won't be needed if i can automate the search and everything 
      redirect_to manage_inventory_path
    end
  end

  def update
    @inventory = Inventory.find(params[:id])
    @inventory.update_attributes(inventory_update_params)
    if Rails.env == "test"
      redirect_to :action => 'manage'
    else
      if request.referer.include? 'admin'
        redirect_to :action => 'index'
      else
        redirect_to :action => 'manage'
      end
    end
  end

  def index
    @index = true 
    @actions = true 
    
    @q = Inventory.where("available is not null").all.ransack(params[:q])
    @inventories = @q.result.includes(:signup)
  end

  def destroy_description
    @inventory = Inventory.find(params[:id])
    @inventory.update_attributes(description: "")
    if request.referer.include? 'admin'
      redirect_to :action => 'index'
    else
      redirect_to :action => 'manage'
    end
  end

  def toggle
    toggled = Inventory.find(params[:id])
    if toggled.available == true
      toggled.update_attributes(available: false)
      # Borrow.where(inventory_id: toggled.id).select { |b| b.status1 == 1 && b.request.pickupdate > Date.today }
    elsif toggled.available == false
      toggled.update_attributes(available: true)
    end
    if request.referer.include? 'admin'
      redirect_to :action => 'index'
    else
      redirect_to :action => 'manage'
    end
  end

  def destroy
    removed = Inventory.find(params[:id])
    removed.update_attributes(available: nil)
    if request.referer.include? 'admin'
      redirect_to :action => 'index'
    else
      redirect_to :action => 'manage'
    end
  end

  def manage
    @pagetitle = "Approve outstanding requests from borrowers"
    @actions = true
    
    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email].downcase)
      if @signup_parent.tos != true || @signup_parent.streetone.blank? || @signup_parent.streettwo.blank? || @signup_parent.zipcode.blank?
        flash[:danger] = "Almost there! We just need a little more info"
        redirect_to edit_signup_path
      else
        @q = @signup_parent.inventories.where("available is not null").ransack(params[:q])
        @inventories = @q.result.includes(:signup)
      end
    end
  end

  def decline_process(borrow_in_question, status1_input)
    inventory_id = borrow_in_question.inventory_id 
    itemlist_id = borrow_in_question.itemlist_id 
    request_id = borrow_in_question.request_id 
    multiple = borrow_in_question.multiple

    similar_borrows = Borrow.where({ itemlist_id: itemlist_id, request_id: request_id, multiple: multiple}).where.not(id: borrow_in_question.id)
    if similar_borrows.select { |b| b.status1 == 1 }.present?
      borrow_in_question.destroy 
    else
      similar_borrows.destroy_all
      borrow_in_question.update_attributes(status1: status1_input, inventory_id: nil)
      if Rails.env == "test"
        RequestMailer.not_found(borrow_in_question, itemlist_id).deliver
      else
        Notfound.new.async.perform(borrow_in_question, itemlist_id)
      end  

    end
  end

  def decline
  #not as many deletes, because we're assuming that you're declining one borrow, not necessarily anything for that date range or from that user, though these could be more advanced options
  #along that same vein you could easily have accept all for a specific item, or for a specific user's request
    declined = Borrow.find_by_id(params[:id])
    
    decline_process(declined, 21)
    
    redirect_to manage_inventory_path
  end

  def accept 
    accepted = Borrow.find_by_id(params[:id])
    accepted.update_attributes(status1: 2)
    if Rails.env == "test"
      RequestMailer.connect_email(accepted).deliver
    else
      Connect.new.async.perform(accepted)
    end 

    inventory_id = accepted.inventory_id
    itemlist_id = accepted.itemlist_id
    request_id = accepted.request_id
    multiple = accepted.multiple

    similar_borrows = Borrow.where(itemlist_id: itemlist_id)
    #delete items that the borrower no longer needs
    similar_borrows.select{ |b| b.request_id == request_id && b.multiple == multiple && b.inventory_id != inventory_id }.each { |b| b.destroy }

    #some things no longer available
    no_longer_available = similar_borrows.select{ |b| b.inventory_id == inventory_id && b.request_id != request_id && b.request.do_dates_overlap(Request.find(request_id)) == "yes"} + similar_borrows.select{ |b| b.inventory_id == inventory_id && b.request_id == request_id && b.multiple != multiple && b.request.do_dates_overlap(Request.find(request_id)) == "yes"}
    no_longer_available.each do |n|
      decline_process(n, 20)
    end

    redirect_to manage_inventory_path
  end

  private

    def inventory_params
      @inventory_params = params["inventory"]
      @inventory_params = @inventory_params.reject { |k, v| (v == "") || ( v == "0" ) }
    end

    def inventory_update_params
      params.require(:inventory).permit(:description)
    end
end