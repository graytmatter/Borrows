json.array!(@entry_codes) do |entry_code|
  json.extract! entry_code, :id, :code, :active
  json.url entry_code_url(entry_code, format: :json)
end
