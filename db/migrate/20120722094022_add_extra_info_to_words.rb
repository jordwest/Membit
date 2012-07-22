class AddExtraInfoToWords < ActiveRecord::Migration
  def change
    change_table :words do |t|
      t.string :type1
      t.string :type2
      t.boolean :honorific
    end
  end
end
