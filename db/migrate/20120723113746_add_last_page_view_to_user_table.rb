class AddLastPageViewToUserTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.datetime :last_pageview
    end
  end
end
