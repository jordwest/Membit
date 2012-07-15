class AddTagFieldToRegistrationCodes < ActiveRecord::Migration
  def change
    add_column :registration_codes, :tag, :string
  end
end
