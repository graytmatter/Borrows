class InventoriesController < ApplicationController

  before_filter :authenticate, except: [:new, :create, :destroy, :manage, :accept, :decline, :create_borrow]

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
          @signup_parent.inventories.create(itemlist_id: itemlist_id)
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

  def decline 
  #not as many deletes, because we're assuming that you're declining one borrow, not necessarily anything for that date range or from that user, though these could be more advanced options
  #along that same vein you could easily have accept all for a specific item, or for a specific user's request
    declined = Borrow.find_by_id(params[:id])
    
    inventory_id = declined.inventory_id 
    itemlist_id = declined.itemlist_id 
    request_id = declined.request_id 

    if Borrow.where({ itemlist_id: itemlist_id, request_id: request_id }).where.not(id: declined.id).select { |b| b.status1 == 1}.present?
      declined.update_attributes(status1: 21)
    else
      Borrow.where({ itemlist_id: itemlist_id, request_id: request_id }).where.not(id: declined.id).destroy_all
      declined.update_attributes(status1: 21, inventory_id: nil)
      RequestMailer.not_found(declined, itemlist_id).deliver 
    end
    
    redirect_to manage_inventory_path
  end

  def accept 
    accepted = Borrow.find_by_id(params[:id])
    accepted.update_attributes(status1: 2)
    RequestMailer.connect_email(accepted).deliver

    inventory_id = accepted.inventory_id
    itemlist_id = accepted.itemlist_id
    request_id = accepted.request_id

    #delete items that the borrower no longer needs
    Borrow.where({ itemlist_id: itemlist_id, request_id: request_id }).where.not(inventory_id: inventory_id).destroy_all

    #some things no longer available
    no_longer_available = Borrow.where({ itemlist_id: itemlist_id, inventory_id: inventory_id}).where.not(request_id: request_id).update_all(status1: 20)
    no_longer_available.each do |borrow|
      borrow.not_found_email_check
      if Borrow.where({itemlist_id:itemlist_id, request_id:request_id}).where.not(inventory_id: inventory_id).where(status1 == 1).present?
        borrow.destroy
      else
        borrow.update_attributes(inventory_id: nil)
        Borrow.where({itemlist_id:itemlist_id, request_id:request_id}).where.not(inventory_id: inventory_id).destroy_all
        RequestMailer.not_found(borrow, borrow.itemlist_id).deliver 
      end
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