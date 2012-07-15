class AddPrintedToRegistrationCodes < ActiveRecord::Migration
  def change
    add_column :registration_codes, :printed, :boolean
  end
end
