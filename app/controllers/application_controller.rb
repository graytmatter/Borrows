class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN_ID"] && password == ENV["ADMIN_PASSWORD"]
    end
  end

  def decline_process_test(borrow_in_question, status1_input)
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

end
