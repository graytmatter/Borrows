class InventoriesController < ApplicationController

  before_filter :authenticate, except: [:new, :create, :destroy, :manage, :accept]

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
        @q = @signup_parent.inventories.ransack(params[:q])
        @inventories = @q.result.includes(:signup)
      end
    end
  end

  def accept 
    inventory_id = params[:inventory_id].to_i
    itemlist_id = params[:itemlist_id].to_i
    request_id = params[:request_id].to_i

    accepted = Borrow.where({ itemlist_id: itemlist_id, request_id: request_id, inventory_id: inventory_id }) 
    accepted.update_attributes(status1: Status.find_by_name("Connected").id)
    RequestMailer.connect_email(accepted)

    no_longer_needed = Borrow.where({ itemlist_id: itemlist_id, request_id: request_id }).where.not(inventory_id: inventory_id)
    no_longer_needed.each { |b| b.update_attributes(status1: Status.find_by_name("Borrower already got it").id) }
    
    may_no_longer_be_available = Borrow.where({ itemlist_id: itemlist_id, inventory_id: inventory_id }).where.not(request_id: request_id)
    may_no_longer_be_available.each do |borrow|
      if borrow.request.do_dates_overlap(accepted.request) == "yes"
        borrow.update_attributes(status1: Status.find_by_name("Lender already gave it").id) 
        #Whenever something is cancelled, check if the borrower has no other options, and if so, send them a not found email
        if Borrow.where({ request_id: borrow.request.id, itemlist_id: itemlist_id }).select { |not_cancelled_borrow| Status.where(statuscategory_id: Statuscategory.find_by_name("1 - Did use PB")).include? not_cancelled_borrow.status1 }.count == 0
          RequestMailer.not_found(Borrow.find_by_id(borrow)).deliver
        end
      end
    end
    redirect_to manage_inventory_path
  end

  def decline 
  #not as many deletes, because we're assuming that you're declining one borrow, not necessarily anything for that date range or from that user, though these could be more advanced options
  #along that same vein you could easily have accept all for a specific item, or for a specific user's request
    inventory_id = params[:inventory_id].to_i
    itemlist_id = params[:itemlist_id].to_i
    request_id = params[:request_id].to_i

    declined = Borrow.where({ itemlist_id: itemlist_id, request_id: request_id, inventory_id: inventory_id }) 
    declined.update_attributes(status1: Status.find_by_name("Lender declined").id)

    if Borrow.where({ request_id: request_id, itemlist_id: itemlist_id }).select { |not_cancelled_borrow| Status.where(statuscategory_id: Statuscategory.find_by_name("1 - Did use PB")).include? not_cancelled_borrow.status1 }.count == 0
        RequestMailer.not_found(Borrow.find_by_id(borrow)).deliver
    end
    
    redirect_to manage_inventory_path
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
          @signup_parent.inventories.create(itemlist_id: itemlist_id)
        end
      end
      flash[:success] = "Thank you so much! We'll be in touch when a borrower comes-a-knockin'!"
      # @signup_parent.inventories.each do |i|
      #   i.save_spreadsheet
      # end
      # InventoryMailer.upload_email(@signup_parent, items_to_be_saved).deliver
      # soon inventorymailer won't be needed if i can automate the search and everything 
      redirect_to new_inventory_path
    end
  end

  def update
    @inventory = Inventory.find(params[:id])
    @inventory.update_attributes(inventory_update_params)
    if request.referer.include? 'admin'
      redirect_to :action => 'index'
    else
      redirect_to :action => 'manage'
    end
  end

  def index
    @q = Inventory.ransack(params[:q])
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

  def destroy
    @destroyed = Inventory.find(params[:id])
    Inventory.find(params[:id]).destroy
    # if request.referer.include? 'admin'
      redirect_to :action => 'index'
    # else
    #   @signup_parent = Signup.find_by_email(session[:signup_email].downcase)
    #   InventoryMailer.delete_email(@signup_parent, @destroyed).deliver
    #   redirect_to :action => 'manage'
    # end
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