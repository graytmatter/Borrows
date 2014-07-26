class Times_to_create
	include SuckerPunch::Job

	def perform(quantity, matched_inventory_ids, itemlist_id)
		ActiveRecord::Base.connection_pool.with_connection do 
			times_to_create(quantity, matched_inventory_ids, itemlist_id)
		end
	end
end