class CreateRegistrationCodes < ActiveRecord::Migration
  def change
    create_table :registration_codes do |t|
      t.string :code
      t.string :role
      t.boolean :used

      t.timestamps
    end
  end
end
