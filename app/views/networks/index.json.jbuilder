json.array!(@networks) do |network|
  json.extract! network, :id, :fb_id, :name, :fb_fans
  json.url network_url(network, format: :json)
end
