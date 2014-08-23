json.array!(@lenders) do |json, lender|
  json.(lender, :id, :email, :latitude, :longitude)
  json.inventories lender.inventories do |json, inventory|
    json.id inventory.id
    json.name Itemlist.find_by_id(inventory.itemlist_id).name
    json.description inventory.description 
  end
end
