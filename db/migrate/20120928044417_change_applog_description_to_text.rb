class ChangeApplogDescriptionToText < ActiveRecord::Migration
  def up
  	  change_column :app_logs, :details, :text
  end

  def down
  	  change_column :app_logs, :details, :string
  end
end
