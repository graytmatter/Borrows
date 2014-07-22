module Notfound
  
  def not_found_email_check
    if Borrow.where({ request_id: self.request_id, itemlist_id: self.itemlist_id }).select { |not_cancelled_borrow| Status.where(statuscategory_id: Statuscategory.find_by_name("1 - Did use PB")).include? not_cancelled_borrow.status1 }.count == 0
        RequestMailer.not_found(self).deliver
    end
  end

end
