json.array!(@titles) do |title|
  json.extract! title, :id, :Title
  json.url title_url(title, format: :json)
end