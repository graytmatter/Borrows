class CreationWorker
  include SuckerPunch::Worker
  def perform(quantity, matched_inventory_ids, itemlist_id)
		ActiveRecord::Base.connection_pool.with_connection do 
			multiple_counter = 1
		    quantity.times do
		      matched_inventory_ids.each_with_index do |inventory_id, index|
		        # If there exists borrows with that same inventory id and request id, i.e., the borrower requests multiple of same thing, then create the record with a default status of where lender already gave it out
		        if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).present? 
		          if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.present?
		            if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.select { |b| b.request.signup.email.downcase == @requestrecord.signup.email.downcase }.present?
		              if index == 0
		                # not_available_borrow = create_borrow(@requestrecord, itemlist_id, multiple_counter, nil, "not available")
		                repeat_borrow = Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.select { |b| b.request.signup.email.downcase == @requestrecord.signup.email.downcase }.first
		                if Rails.env == "test"
		                  RequestMailer.repeat_borrow(repeat_borrow, itemlist_id).deliver
		                else
		                  Repeatborrow.new.async.perform(repeat_borrow, itemlist_id)
		                end     
		              end
		            else
		              if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.select { |b| b.request.signup.email != @requestrecord.signup.email }.select { |b| ([2,3].include? b.status1) == false }.present? 
		                if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.select { |b| ([2,3].include? b.status1) == true}.select { |b| b.inventory_id == inventory_id }.present?
		                  if index == 0
		                    not_available_borrow = create_borrow(@requestrecord, itemlist_id, multiple_counter, nil, "not available")
		                    if Rails.env == "test"
		                      RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
		                    else
		                      Notfound.new.async.perform(not_available_borrow, itemlist_id)
		                    end  
		                  end
		                else
		                  create_borrow(@requestrecord, itemlist_id, multiple_counter, inventory_id, "checking")
		                end
		              else
		                if index == 0
		                  not_available_borrow = create_borrow(@requestrecord, itemlist_id, multiple_counter, nil, "not available")
		                  if Rails.env == "test"
		                    RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
		                  else
		                    Notfound.new.async.perform(not_available_borrow, itemlist_id)
		                  end  
		                end
		              end
		            end
		          else
		            create_borrow(@requestrecord, itemlist_id, multiple_counter, inventory_id, "checking")
		          end
		        else
		          create_borrow(@requestrecord, itemlist_id, multiple_counter, inventory_id, "checking")
		        end
		      end
		    multiple_counter += 1
		    end
		end
	end
end