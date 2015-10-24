json.array!(@games) do |game|
  json.extract! game, :id, :gamehash, :trainerhash, :sethash, :gametempid, :description
  json.url game_url(game, format: :json)
end
