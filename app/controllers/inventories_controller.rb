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
    borrow_id = params[:borrow_id].to_i
    @requestrecord = Borrow.find_by_id(borrow_id).request
    Borrow.find_by_id(borrow_id).update_attributes(status1: Status.find_by_name("Connected").id)
    Invenborrow.where(borrow_id: borrow_id).where(inventory_id: inventory_id).update_all(accepted: true)
    Invenborrow.where(borrow_id: borrow_id).where.not(inventory_id: inventory_id).destroy_all
    Invenborrow.where(inventory_id: inventory_id).where.not(borrow_id: borrow_id).all.each do |invenborrow|
      invenborrow.destroy if @requestrecord.do_dates_overlap(Borrow.find_by_id(invenborrow.id).request) == "yes"
    end
    RequestMailer.connect_email(borrow_id, inventory_id, @requestrecord).deliver
    
    if Invenborrow.where(borrow_id: borrow_id).where(accepted: true).count == 0 
      Borrow.find_by_id(borrow_id).update_attributes(status1: Status.where("name LIKE ?", "%not available%").first.id)
      RequestMailer.not_found(borrow_id, @requestrecord).deliver
    end
    
    redirect_to manage_inventory_path
  end

  def decline 
  #not as many deletes, because we're assuming that you're declining one borrow, not necessarily anything for that date range or from that user, though these could be more advanced options
  #along that same vein you could easily have accept all for a specific item, or for a specific user's request
    inventory_id = params[:inventory_id].to_i
    borrow_id = params[:borrow_id].to_i
    @requestrecord = Borrow.find_by_id(borrow_id).request
    Invenborrow.where(borrow_id: borrow_id).where(inventory_id: inventory_id).destroy
    
    if Invenborrow.where(borrow_id: borrow_id).where(accepted: true).count == 0 
      Borrow.find_by_id(borrow_id).update_attributes(status1: Status.where("name LIKE ?", "%not available%").first.id)
      RequestMailer.not_found(borrow_id, @requestrecord).deliver
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