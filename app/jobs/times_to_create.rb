class Times_to_create
	include SuckerPunch::Job

	def perform(requestrecord_id, borrowparams)
		ActiveRecord::Base.connection_pool.with_connection do 
			@requestrecord = Request.find_by_id(requestrecord_id)
			borrowparams.each do |itemlist_id, quantity|
				
	          matched_inventory_ids = Array.new
      
		      Inventory.where.not(signup_id: @requestrecord.signup.id).where(itemlist_id: itemlist_id).each do |i|
		        if Geography.find_by_zipcode(i.signup.zipcode).present? && Geography.find_by_zipcode(@requestrecord.signup.zipcode).present?
		          if Geography.find_by_zipcode(i.signup.zipcode).county == Geography.find_by_zipcode(@requestrecord.signup.zipcode).county
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
	              if Rails.env == "test"
	                RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
	              else
	                Notfound.new.async.perform(not_available_borrow, itemlist_id)
	              end  
	            end
	              multiple_counter = 1
	              matched_inventory_ids.count.times do
	                matched_inventory_ids.each_with_index do |inventory_id, index|
	                  # If there exists borrows with that same inventory id and request id, i.e., the borrower requests multiple of same thing, then create the record with a default status of where lender already gave it out
	                  if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).present? 
	                    if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.present?
	                      if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.select { |b| b.request.signup.email.downcase == @requestrecord.signup.email.downcase }.present?
	                        if index == 0
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
	                              not_available_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: nil, status1: 20)
	                              if Rails.env == "test"
	                                RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
	                              else
	                                Notfound.new.async.perform(not_available_borrow, itemlist_id)
	                              end  
	                            end
	                          else
	                            new_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: inventory_id, status1: 1)
	                          end
	                        else
	                          if index == 0
	                            not_available_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple, inventory_id: nil, status1: 20)
	                            if Rails.env == "test"
	                              RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
	                            else
	                              Notfound.new.async.perform(not_available_borrow, itemlist_id)
	                            end  
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
	          else
	            multiple_counter = 1
	            quantity.to_i.times do
	              matched_inventory_ids.each_with_index do |inventory_id, index|
	                # If there exists borrows with that same inventory id and request id, i.e., the borrower requests multiple of same thing, then create the record with a default status of where lender already gave it out
	                if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).present? 
	                  if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.present?
	                    if Borrow.where({ itemlist_id: itemlist_id }).where.not(request_id: @requestrecord.id).select { |b| b.request.do_dates_overlap(@requestrecord) == "yes" }.select { |b| b.request.signup.email.downcase == @requestrecord.signup.email.downcase }.present?
	                      if index == 0
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
	                            not_available_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: nil, status1: 20)
	                            if Rails.env == "test"
	                              RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
	                            else
	                              Notfound.new.async.perform(not_available_borrow, itemlist_id)
	                            end  
	                          end
	                        else
	                          new_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: inventory_id, status1: 1)
	                        end
	                      else
	                        if index == 0
	                          not_available_borrow = @requestrecord.borrows.create(itemlist_id: itemlist_id, multiple: multiple_counter, inventory_id: nil, status1: 20)
	                          if Rails.env == "test"
	                            RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
	                          else
	                            Notfound.new.async.perform(not_available_borrow, itemlist_id)
	                          end  
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
	        end
		end
	end
end