class CreateAppLogs < ActiveRecord::Migration
  def change
    create_table :app_logs do |t|
      t.references :user
      t.string :type
      t.string :details
      t.integer :var1
      t.integer :var2

      t.timestamps
    end
    add_index :app_logs, :user_id
  end
end
