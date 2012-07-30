object @card
attributes :id, :next_due, :failed, :new, :last_review
node :reviewed do |n|
  false
end
child(:word) do
  attributes :expression, :reading, :meaning
end
