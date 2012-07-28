object @card
attributes :id, :next_due, :failed, :new
node :reviewed do |n|
  false
end
child(:word) do
  attributes :expression, :reading, :meaning
end
