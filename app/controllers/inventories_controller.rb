class InventoriesController < ApplicationController
  before_filter :authenticate, except: [:new, :create, :destroy]

  def new
    itemlist
    @pagetitle = "What would you like to lend?"

    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
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
    itemlist
    @pagetitle = "What would you like to lend?"

    @signup_parent = Signup.find_by_email(session[:signup_email])
    @q = @signup_parent.inventories.ransack(params[:q])
    @inventories = @q.result.includes(:signup)
    # above required because when new is re-rendered, it's actually the create action 
    
    inventory_params
    
    items_to_be_saved = []
    @inventory_params.each do |item, quantity|
      quantity = quantity.to_i
      quantity.times do
        items_to_be_saved << ({:item_name => item })
      end
    end

    if items_to_be_saved.blank?
      @signup_parent.errors[:base] << "Please select at least one item to lend"
      render 'new'
    else
      @signup_parent.inventories.create items_to_be_saved
      flash[:success] = "Thank you so much! We'll be in touch when a borrower comes-a-knockin'!"
      
        # @signup_parent.inventories.each do |i|
        #   i.save_spreadsheet
        # end
        InventoryMailer.upload_email(@signup_parent, items_to_be_saved).deliver

      redirect_to new_inventory_path
    end
  end

  # def update
  #   @signup_parent = Signup.find_by_email(session[:signup_email])
  #   @q = @signup_parent.inventories.ransack(params[:q])
  #   @inventories = @q.result.includes(:signup)
  #   redirect_to :action => 'new'
  # end

  def admin_edit
    @inventory = Inventory.find(params[:id])
  end

  def admin_update
    @inventory = Inventory.find(params[:id])
    if @inventory.update_attributes(inventory_update_params)
      redirect_to :action => 'index'
    else
      render 'admin_edit'
    end
  end

  def edit
    @inventory = Inventory.find(params[:id])
  end

  def update
    @inventory = Inventory.find(params[:id])
    if @inventory.update_attributes(inventory_update_params)
      redirect_to :action => 'new'
    else
      render 'edit'
    end
  end

  def index
    @q = Inventory.ransack(params[:q])
    @inventories = @q.result.includes(:signup)
  end

  def destroy
    @destroyed = Inventory.find(params[:id])
    Inventory.find(params[:id]).destroy
    if request.referer.include? 'admin'
      redirect_to :action => 'index'
    else
      @signup_parent = Signup.find_by_email(session[:signup_email])
      InventoryMailer.delete_email(@signup_parent, @destroyed).deliver
      redirect_to :action => 'new'
    end

    #Note currently these changes are not affecting spreadsheet!
  end

  private

    def inventory_params
      params.permit[:quantity]
      @inventory_params = params.reject { |k, v| (v == "") || ( v == "0" ) || ( v.length > 2 ) }
    end

    def inventory_update_params
      params.require(:inventory).permit(:description)
    end
end