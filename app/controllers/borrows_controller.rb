class BorrowsController < ApplicationController
  before_filter :authenticate, except: [:cancel] unless Rails.env == "test"
  
  def index
    @inventory_id_collection = Hash.new
    Borrow.where("inventory_id is not null").pluck("inventory_id").uniq.each do |i|
      if @inventory_id_collection.has_key?("#{Inventory.find_by_id(i).signup.email}")
        @inventory_id_collection["#{Inventory.find_by_id(i).signup.email}"] << i
      else
        @inventory_id_collection["#{Inventory.find_by_id(i).signup.email}"] = Array.new
        @inventory_id_collection["#{Inventory.find_by_id(i).signup.email}"] << i
      end
    end

    @inventory_id_collection.each do |k,v|
      @inventory_id_collection[k] = v*","
    end

    @zipcode_collection = Hash.new
    Borrow.all.pluck("request_id").select{ |r| Geography.find_by_zipcode(Request.find_by_id(r).signup.zipcode).present? }.uniq.each do |r|
      if @zipcode_collection.has_key?(Geography.find_by_zipcode(Request.find_by_id(r).signup.zipcode).county)
        @zipcode_collection[Geography.find_by_zipcode(Request.find_by_id(r).signup.zipcode).county] << Request.find_by_id(r).signup.zipcode
      else
        @zipcode_collection[Geography.find_by_zipcode(Request.find_by_id(r).signup.zipcode).county] = Array.new
        @zipcode_collection[Geography.find_by_zipcode(Request.find_by_id(r).signup.zipcode).county] << Request.find_by_id(r).signup.zipcode
      end
    end

    @zipcode_collection.each do |k,v|
      @zipcode_collection[k] = v.uniq!
      @zipcode_collection[k] = v*","
    end

    query = params[:q]
    query["inventory_id_eq_any"] = params[:q]["inventory_id_eq_any"].split(',') if query != nil && query["inventory_id_eq_any"] != nil
    query["request_signup_zipcode_eq_any"] = params[:q]["request_signup_zipcode_eq_any"].split(',') if query != nil && query["request_signup_zipcode_eq_any"] != nil && query != nil
    @q = Borrow.ransack(query)
    @borrows = @q.result.includes(:request => :signup)
  end

  def edit
  	@borrow = Borrow.find(params[:id])
  end

  def update
  	@borrow = Borrow.find(params[:id])
  	
    if @borrow.update_attributes(borrow_params)
  		flash[:success] = "Update successful"
  		redirect_to '/admin/borrows'
  	else
  		render 'edit'
  	end
  end

  def cancel
    @borrow = Borrow.find(params[:id])

    if @borrow.status1 == 2
      if @borrow.update_attributes(cancel_params)
        flash[:success] = "Request cancelled"
        redirect_to '/requests/manage'
        #cancellation email to both borrower and lender
      else
        render '/requests/manage'
      end
    else
      if @borrow.update_attributes(cancel_params)
        flash[:success] = "Request cancelled"
        redirect_to '/requests/manage'
      else
        render '/requests/manage'
      end
    end

  end

  private

  def borrow_params
  	params.require(:borrow).permit(:status1, :status2, :inventory_id, request_attributes: [:id, :pickupdate, :returndate]) 
  end

  def cancel_params
    params.require(:borrow).permit(:status1, :status2)
  end

end