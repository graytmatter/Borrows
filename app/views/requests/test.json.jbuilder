json.array!(@lenders) do |lender|
  json.(lender, :id, :email, :latitude, :longitude)
  json.inventories lender.inventories do |inventory|
    json.id inventory.id
    json.name Itemlist.find_by_id(inventory.itemlist_id).name
    json.description inventory.description 
    json.category Categorylist.find_by_id(Itemlist.find_by_id(inventory.itemlist_id).categorylist_id).name

    json.requests @requestrecords.select { |r| (r.borrows.select { |b| b.inventory_id == inventory.id }.count) > 0 && r.pickupdate.present? && r.returndate.present? } do |request|
      json.pickupdate request.pickupdate.to_date
      json.returndate request.returndate.to_date
    end
  end
end
