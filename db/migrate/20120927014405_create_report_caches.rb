class CreateReportCaches < ActiveRecord::Migration
  def change
    create_table :report_caches do |t|
      t.string :key
      t.text :data

      t.timestamps
    end
  end
end
