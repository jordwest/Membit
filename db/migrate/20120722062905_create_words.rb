class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :expression
      t.string :reading
      t.string :meaning
      t.float :average_easiness_factor
      t.integer :reviewed_count

      t.timestamps
    end
  end
end
