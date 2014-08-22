json.array!(@lenders) do |json, lender|
  json.(lender, :id, :email, :latitude, :longitude)
  json.inventories lender.inventories do |json, inventory|
    json.(inventory, :id, :itemlist_id, :description)
  end
end
