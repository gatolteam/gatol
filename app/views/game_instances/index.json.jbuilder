json.array!(@game_instances) do |game_instance|
  json.extract! game_instance, :id
  json.url game_instance_url(game_instance, format: :json)
end
