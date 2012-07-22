class AddOrderColumnToWords < ActiveRecord::Migration
  def change
    add_column :words, :order, :integer
  end
end
