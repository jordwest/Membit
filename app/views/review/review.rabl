object false

node :stats do
  object @stats
end

child @cards => "cards" do
  extends "review/cards"
end