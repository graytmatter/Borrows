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
          @signup_parent.inventories.create(itemlist_id: itemlist_id, available: true)
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

    if Borrow.where({ itemlist_id: itemlist_id, request_id: request_id, multiple: multiple}).where.not(id: borrow_in_question.id).where(status1: 1).present?
      borrow_in_question.destroy 
      #select { |b| b.request.pickupdate != borrow_in_question.request.pickupdate && b.request.returndate != borrow_in_question.request.returndate }
    else
      Borrow.where({ itemlist_id: itemlist_id, request_id: request_id, multiple: multiple}).where.not(id: borrow_in_question.id).destroy_all
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

    #delete items that the borrower no longer needs
    Borrow.where({ itemlist_id: itemlist_id, request_id: request_id, multiple: multiple}).where.not(inventory_id: inventory_id).destroy_all

    #some things no longer available
    no_longer_available1 = Borrow.where({ itemlist_id: itemlist_id, inventory_id: inventory_id}).where.not(request_id: request_id).select { |b| b.request.do_dates_overlap(Request.find(request_id)) == "yes"}.each do |no_longer_available|
      decline_process(no_longer_available, 20)
    end

    no_longer_available2 = Borrow.where({ itemlist_id: itemlist_id, inventory_id: inventory_id, request_id: request_id}).where.not(multiple: multiple).select { |b| b.request.do_dates_overlap(Request.find(request_id)) == "yes"}.each do |no_longer_available|
      decline_process(no_longer_available, 20)
    end

    redirect_to manage_inventory_path
  end

  private

    def inventory_params
      #params.require(:inventory).permit(:itemlist_id, :quantity )
      #params.permit(inventory: [{:itemlist_id => :quantity}] )
      @inventory_params = params["inventory"]
      #@inventory_params = params.permit("inventory")
      #@inventory_params = params.permit(:inventory)
      @inventory_params = @inventory_params.reject { |k, v| (v == "") || ( v == "0" ) }
    end

    def inventory_update_params
      params.require(:inventory).permit(:description)
    end
end