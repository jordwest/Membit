require 'csv'

module Admin::DataoutputHelper
  def model_to_csv(rows)
    cols = Review.new.attributes.keys - Review.protected_attributes.to_a

    if(!Review.new.export_attributes.nil?)
      cols += Review.new.export_attributes
    end

    CSV.generate do |csv|
      # Generate headings
      csv_row = []
      cols.each do |col|
        csv_row << col
      end

      csv << csv_row

      # Add rows
      rows.each do |row|
        csv_row = []
        cols.each do |col|
          csv_row << row.send(col)
        end
        csv << csv_row
      end
    end
  end
end
