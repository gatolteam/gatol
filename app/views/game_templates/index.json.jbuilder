json.array!(@game_templates) do |game_template|
  json.extract! game_template, :id
  json.url game_template_url(game_template, format: :json)
end
