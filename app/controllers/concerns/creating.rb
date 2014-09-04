module Creating

  def actual_creation(cycles_required, matched_inventory_ids, itemlist_id)
    multiple_counter = 1
    cycles_required.times do
      matched_inventory_ids.each_with_index do |inventory_id, index|
        borrows = Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).includes(:request => :signup)
        if borrows.present? 
          overlapping_borrows = borrows.select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }
          if overlapping_borrows.present?
            if overlapping_borrows.select { |b| b.request.signup.email.downcase == @requestrecord.signup.email.downcase }.present?
              if index == 0
                repeat_borrow = overlapping_borrows.select { |b| b.request.signup.email.downcase == @requestrecord.signup.email.downcase }.first
                Repeatborrow.new.async.perform(repeat_borrow, itemlist_id)    
              end
            else
              if overlapping_borrows.select { |b| b.request.signup.email != @requestrecord.signup.email }.select { |b| ([2,3].include? b.status1) == false }.present? 
                if overlapping_borrows.select { |b| ([2,3].include? b.status1) == true}.select { |b| b.inventory_id == inventory_id }.present?
                  if index == 0
                    not_available_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: nil, status1: 20)
                    Notfound.new.async.perform(not_available_borrow, itemlist_id)
                  end
                else
                  new_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: inventory_id, status1: 1)
                end
              else
                if index == 0
                  not_available_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: nil, status1: 20)
                  Notfound.new.async.perform(not_available_borrow, itemlist_id)
                end
              end
            end
          else
            new_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: inventory_id, status1: 1)
          end
        else
          new_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: inventory_id, status1: 1)
        end
      end
    multiple_counter += 1
    end
  end

  def times_to_create(requestrecord_id, borrowparams)
    @requestrecord = Request.find_by_id(requestrecord_id)
    borrowparams.each do |itemlist_id, quantity|
      matched_inventory_ids = Array.new
      
      Inventory.where.not(signup_id: @requestrecord.signup.id).where(itemlist_id: itemlist_id, available: true).each do |i|
        lender_location = Geography.find_by_zipcode(i.signup.zipcode)
        borrower_location = Geography.find_by_zipcode(@requestrecord.signup.zipcode)

        if lender_location.present? && borrower_location.present?
          if lender_location.county == borrower_location.county
            matched_inventory_ids << i.id
          end
        end
      end

      if quantity.to_i > matched_inventory_ids.count
        difference = quantity.to_i - matched_inventory_ids.count
        multiple_counter = 0
        difference.times do 
          not_available_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: nil, status1: 20)
          multiple_counter += 1
          Notfound.new.async.perform(not_available_borrow, itemlist_id)  
        end
        actual_creation(matched_inventory_ids.count, matched_inventory_ids, itemlist_id)
      else
        actual_creation(quantity.to_i, matched_inventory_ids, itemlist_id) 
      end
    end
  end
end